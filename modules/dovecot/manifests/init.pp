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
}
