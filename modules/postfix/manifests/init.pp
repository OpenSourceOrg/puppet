class postfix {
  package { 'postfix':
    ensure => present
  }
  service { 'postfix':
    ensure => running,
    require => Package['postfix']
  }
}
