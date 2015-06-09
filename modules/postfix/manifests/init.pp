class postfix ($use_mailman = false, $destinations = []) {
  package { 'postfix':
    ensure => present
  }
  service { 'postfix':
    ensure => running,
    require => Package['postfix']
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
                ],
    lens => 'Postfix_Main.lns',
    incl => '/etc/postfix/main.cf',
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  package { 'spamassassin':
    ensure => present
  }
  service { 'spamassassin':
    ensure => running,
    require => [
                Package['spamassassin'],
                Augeas['/etc/default/spamassassin'],
                ]
  }
  augeas { '/etc/default/spamassassin':
    context => '/files/etc/default/spamassassin',
    changes => "set ENABLED 1",
    lens => 'Shellvars.lns',
    incl => '/etc/default/spamassassin',
    require => Package['spamassassin'],
    notify => Service['spamassassin'],
  }

  postfix::postconf { 'smtp/inet':
    value => 'smtp      inet  n       -       -       -       -       smtpd        -o content_filter=spamassassin'
  }
  postfix::postconf { 'spamassassin/unix':
    value => 'spamassassin unix -     n       n       -       -       pipe        user=spamd argv=/usr/bin/spamc -f -e          /usr/sbin/sendmail -oi -f ${sender} ${recipient}'
  }

}
