class postfix::opendkim (
  $domainname = undef,
  $privatekey = undef,
  $dnsrecord = undef,
) {
  unless $domainname { fail('domainname cannot be empty') }
  unless $privatekey { fail('privatekey cannot be empty') }

  $pkgs = ['opendkim', 'opendkim-tools']

  package { $pkgs:
    ensure => present
  }

  file { '/etc/opendkim.conf':
    ensure  => present,
    content => template('postfix/opendkim.conf.erb'),
    notify  => Service['opendkim'],
  }
  file { '/etc/default/opendkim':
    ensure  => present,
    content => template('postfix/opendkim.default.erb'),
    notify  => Service['opendkim'],
  }

  service { 'opendkim':
    ensure => running,
    enable => true,
  }

  augeas { '/etc/postfix/main.cf-dkim':
    context => '/files/etc/postfix/main.cf',
    changes => [
                'set milter_default_action accept',
                'set milter_protocol 2',
                'set smtpd_milters inet:localhost:8891',
                'set non_smtpd_milters inet:localhost:8891',
                ],
    require => Package['postfix'],
    notify  => Service['postfix'],
  }

  file { '/etc/mail/dkim.key':
    ensure  => present,
    mode    => '600',
    content => $privatekey,
    notify  => Service['opendkim'],
  }
  if $dnsrecord {  # for informative/documnetation purposes only
    file { '/etc/mail/dkim.record.txt':
      ensure  => present,
      content => $dnsrecord,
    }
  }

}
