class fail2ban ($jails = ['ssh', 'postfix', 'sasl', 'dovecot']) {

  package { 'fail2ban':
    ensure => installed
  }

  file { '/etc/fail2ban/jail.conf':
    ensure  => present,
    content => template('fail2ban/jail.conf.erb'),
    notify  => Service['fail2ban'],
  }

  service { 'fail2ban':
    ensure => running,
    enable => true,
  }

}
