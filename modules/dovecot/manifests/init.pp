class dovecot {
  package { 'dovecot-core':
    ensure => present
  }
  service { 'dovecot':
    ensure => running,
    require => Package['dovecot-core']
  }

  file { '/etc/dovecot/authusers.d':
    owner => dovecot,
    group => root,
    mode => '0600',
    ensure => directory,
    require => Package['dovecot-core'],
    notify => Exec['refresh-dovecot-users']
  }

  exec { 'refresh-dovecot-users':
    command => 'run-parts --list --regex "^[a-z0-9.-]*\$" /etc/dovecot/authusers.d | xargs cat > /etc/dovecot/authusers ; chown dovecot:root /etc/dovecot/authusers ; chmod 600 /etc/dovecot/authusers',
    path => [
             '/usr/bin',
             '/usr/sbin',
             '/bin',
             '/sbin'],
    refreshonly => true,
    notify => Service['dovecot']
  }

  augeas { '/etc/dovecot/conf.d/10-master.conf_unix_listener':
    context => '/files/etc/dovecot/conf.d/10-master.conf',
    changes => [
                "set service[.='auth']/unix_listener[.='/var/spool/postfix/private/auth'] '/var/spool/postfix/private/auth'",
                "set service[.='auth']/unix_listener[.='/var/spool/postfix/private/auth']/mode 0666",
                "set service[.='auth']/unix_listener[.='/var/spool/postfix/private/auth']/user postfix",
                "set service[.='auth']/unix_listener[.='/var/spool/postfix/private/auth']/group postfix",
                ],
    lens => 'Dovecot.lns',
    incl => '/etc/dovecot/conf.d/10-master.conf',
    require => Package['dovecot-core'],
    notify => Service['dovecot'],
  }

  augeas { '/etc/dovecot/conf.d/10-auth.conf_passdb':
    context => '/files/etc/dovecot/conf.d/10-auth.conf',
    changes => [
                "set passdb/driver passwd-file",
                "set passdb/args 'scheme=PLAIN username_format=%u /etc/dovecot/authusers'",
                ],
    lens => 'Dovecot.lns',
    incl => '/etc/dovecot/conf.d/10-auth.conf',
    require => Package['dovecot-core'],
    notify => Service['dovecot'],
  }
}
