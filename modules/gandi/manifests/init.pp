class gandi {
  package { 'gandi-hosting-vm2':
    ensure => installed
  }
  file { '/etc/default/gandi':
    ensure  => present,
    content => template('gandi/etc-default.erb'),
  }
}
