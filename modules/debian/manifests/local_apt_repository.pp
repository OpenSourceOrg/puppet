class debian::local_apt_repository {

  package { 'local-apt-repository':
    ensure => present
  }

  file { '/srv/local-apt-repository':
    require => Package['local-apt-repository'],
    ensure  => directory,
    mode    => 0755,
    user    => 'root',
    group   => 'root',
  }

}
