class opensourceorg::license_api_server
  ($conffile = '/etc/api.opensource.org/licenses.json')
{

  package { 'opensource.org-api':
    ensure  => installed,
    require => Package['apache2'],
  }

  file { $conffile:
    ensure  => present,
    notify  => Service['apache2']
  }

  apache2::module { 'proxy': }
  apache2::module { 'proxy_http': }

}
