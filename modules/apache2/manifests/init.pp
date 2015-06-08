class apache2 ($use_mailman = false) {
  package { 'apache2':
    ensure => present,
  }
  service { 'apache2':
    ensure => running,
    require => Package['apache2']
  }
}
