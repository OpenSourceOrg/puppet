class apache2 ($use_php = false) {
  package { 'apache2':
    ensure => present,
  }
  service { 'apache2':
    ensure => running,
    require => Package['apache2']
  }

  if $use_php {
    package { 'libapache2-mod-php5':
      ensure => present,
      notify => Service['apache2']
    }
  }
}
