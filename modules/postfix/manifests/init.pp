class postfix (
  $domainname = undef,
  $destinations = [],
  $use_mailman = false,
  $use_smtp_auth = false,
  $use_dkim = false
) {
  unless $domainname {
    fail('domainname cannot be empty')
  }

  package { 'postfix':
    ensure => present
  }
  service { 'postfix':
    ensure => running,
    require => Package['postfix'],
  }

  file { '/etc/mailname':
    content => "$fqdn\n"
  }

  if $use_mailman {
    $alias_maps = 'hash:/etc/aliases, hash:/var/lib/mailman/data/aliases'
  } else {
    $alias_maps = 'hash:/etc/aliases'
  }

  $defaultdests = ['$mydomain', '$myhostname', 'localhost', 'localhost.localdomain']
  $mydestinations = inline_template('<%= (@defaultdests+@destinations).join(", ") %>')

  augeas { '/etc/postfix/main.cf-main':
    context => '/files/etc/postfix/main.cf',
    changes => [
                "set alias_maps '$alias_maps'",
                "set alias_database '$alias_maps'",
                "set myorigin /etc/mailname",
                "set inet_protocols all",
                "set empty_address_recipient catchall",
                "set broken_sasl_auth_clients yes",
                "set mydestination '$mydestinations'",
                "rm relayhost",
                "set smtpd_sender_restrictions reject_unknown_sender_domain",
                "set smtpd_use_tls yes",
                "set home_mailbox Maildir/",
                "set maximal_queue_lifetime 1d",
                "set smtpd_recipient_restrictions 'reject_unknown_sender_domain, reject_unknown_recipient_domain, reject_unauth_pipelining, permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'",
                "set content_filter 'smtp-amavis:[127.0.0.1]:10024'",
                ],
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  package { 'spamassassin':
    ensure => present
  }
  service { 'spamassassin':
    ensure => running,
    enable => true,
    require => [
                Package['spamassassin'],
                ]
  }
  augeas { '/etc/default/spamassassin':
    context => '/files/etc/default/spamassassin',
    changes => [
                "set ENABLED 1",
                "set CRON 1",
                "set OPTIONS '\"--create-prefs --max-children 5 --helper-home-dir --username debian-spamd\"'",
                ],
    require => Package['spamassassin'],
    notify => Service['spamassassin'],
  }
  file { '/etc/spamassassin/puppet.cf':
    source => 'puppet:///modules/postfix/spamassassin-config',
    notify => Service['spamassassin'],
  }
  package { 'pyzor':
    ensure => present,
    notify => Exec['pyzor-discover'],
  }
  file { '/etc/spamassassin/.pyzor':
    ensure => directory,
    owner => debian-spamd,
    group => debian-spamd,
    require => Package['spamassassin'],
  }
  exec { 'pyzor-discover':
    path => "/usr/sbin:/usr/bin:/sbin:/bin",
    command => "pyzor --homedir /etc/spamassassin/.pyzor discover",
    user => 'debian-spamd',
    require => Package['spamassassin'],
    unless => 'test -e /etc/spamassassin/.pyzor/servers',
    notify => File['/etc/spamassassin/.pyzor/servers'],
  }
  file { '/etc/spamassassin/.pyzor/servers':
    mode => '0644',
  }
  postfix::postconf { 'smtp':
    type => 'inet',
    private => 'n',
    command => 'smtpd -o content_filter=spamassassin',
    require => Service['spamassassin']
  }
  postfix::postconf { 'spamassassin':
    type => 'unix',
    unpriv => 'n',
    chroot => 'n',
    command => 'pipe user=debian-spamd argv=/usr/bin/spamc -f -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}',
    require => Service['spamassassin']
  }

  package { 'amavisd-new':
    ensure => present
  }
  package { 'clamav-daemon':
    ensure => present
  }
  package { 'clamav-freshclam':
    ensure => present
  }
  postfix::postconf { 'smtp-amavis':
    type => 'unix',
    maxproc => 2,
    command => 'smtp
    -o smtp_data_done_timeout=1200
    -o smtp_send_xforward_command=yes
    -o disable_dns_lookups=yes
    -o max_use=20',
  }
  postfix::postconf { '127.0.0.1:10025':
    private => 'n',
    command => 'smtpd
    -o content_filter=
    -o local_recipient_maps=
    -o relay_recipient_maps=
    -o smtpd_restriction_classes=
    -o smtpd_delay_reject=no
    -o smtpd_client_restrictions=permit_mynetworks,reject
    -o smtpd_helo_restrictions=
    -o smtpd_sender_restrictions=
    -o smtpd_recipient_restrictions=permit_mynetworks,reject
    -o smtpd_data_restrictions=reject_unauth_pipelining
    -o smtpd_end_of_data_restrictions=
    -o mynetworks=127.0.0.0/8
    -o smtpd_error_sleep_time=0
    -o smtpd_soft_error_limit=1001
    -o smtpd_hard_error_limit=1000
    -o smtpd_client_connection_count_limit=0
    -o smtpd_client_connection_rate_limit=0
    -o receive_override_options=no_header_body_checks,no_unknown_recipient_checks'
  }

  if $use_smtp_auth {
    class { 'dovecot': }

    $smtpauthusers = hiera('smtpauthusers')
    $smtpauthusers.each |$h, $v| { dovecot::authuser { "$h": password => "$v" } }

    augeas { '/etc/postfix/main.cf-sasl':
      context => '/files/etc/postfix/main.cf',
      changes => [
                  "set smtpd_sasl_type dovecot",
                  "set smtpd_sasl_path private/auth",
                  "set smtpd_sasl_auth_enable yes",
                  ],
      require => Package['postfix'],
      notify => Service['postfix'],
    }
    postfix::postconf { 'submission':
      private => 'n',
      command => 'smtpd',
    }
  } else {
    augeas { '/etc/postfix/main.cf-sasl':
      context => '/files/etc/postfix/main.cf',
      changes => [
                  "rm smtpd_sasl_type",
                  "rm smtpd_sasl_path",
                  "rm smtpd_sasl_auth_enable",
                  ],
      require => Package['postfix'],
      notify => Service['postfix'],
    }
    augeas { "/etc/postfix/master.cf_nosubmission":
      context => '/files/etc/postfix/master.cf',
      changes => [
                  "rm submission[type = 'inet']",
                  ],
      require => Package['postfix'],
      notify => Service['postfix'],
    }
  }

  if $use_dkim {
    class { 'postfix::opendkim':
      domainname => $domainname
    }
  }
}
