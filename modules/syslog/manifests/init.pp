class syslog($default_period = 'weekly',
             $default_history = 52,
             $syslog_period = 'daily',
             $syslog_history = 30)
{
  package { 'rsyslog':
    ensure => installed
  }
  service { 'rsyslog':
    ensure => running,
    enable => true,
  }

  file { '/etc/logrotate.d/rsyslog':
    ensure  => present,
    content => template('syslog/logrotate.erb'),
  }
}
