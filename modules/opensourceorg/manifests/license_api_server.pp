class opensourceorg::license_api_server
  ($conffile = '/etc/api.opensource.org/licenses.json')
{

  package { 'opensource.org-api':
    ensure => installed
  }

  file { $conffile:
    ensure  => present,
    notify  => Service['apache2']
  }

}
