class opensourceorg::license_api_server (
  $conffile = '/etc/api.opensource.org/licenses.json',
  $data_dir = '/srv/api.opensource.org',
  $user = 'www-data'
) {

  package { 'opensource.org-api':
    ensure  => installed,
    require => Package['apache2'],
  }

  file { $conffile:
    ensure  => present,
    notify  => Service['apache2']
  }

  file { $data_dir:
    ensure => directory,
    mode   => '0755',
    owner  => $user,
    group  => $user,
  }

  apache2::module { 'proxy': }
  apache2::module { 'proxy_http': }

}
