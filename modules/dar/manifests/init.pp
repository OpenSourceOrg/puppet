class dar ($backup_key = undef,
           $backup_dir = undef,
           $log_dir = '/var/log/backup')
{

  unless $backup_key {
    fail('backup_key cannot be empty')
  }
  unless $backup_dir {
    fail('backup_dir cannot be empty')
  }

  package { 'dar':
    ensure => installed
  }
  file { "/${backup_dir}":
    ensure => directory,
    owner  => 'root',
    group  => 'backup',
    mode   => '2770',
  }

  file { '/etc/darrc':
    ensure  => present,
    content => template('dar/darrc.erb'),
  }
  file { '/etc/darrc.exclude':
    ensure  => present,
    content => template('dar/darrc.exclude.erb'),
  }
  file { '/etc/darrc.key':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '600',
    content => template('dar/darrc.key.erb'),
  }

  file { '/etc/cron.d/local-backup':
    ensure  => present,
    content => template('dar/cron.erb'),
  }

  file { '/usr/local/sbin/full_backup':
    ensure  => present,
    content => template('dar/full_backup.erb'),
    mode    => '755',
  }
  file { '/usr/local/sbin/incr_backup':
    ensure  => present,
    content => template('dar/incr_backup.erb'),
    mode    => '755',
  }

  file { $log_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'adm',
    mode   => '2750',
  }
  file { '/etc/logrotate.d/local-backup':
    ensure  => present,
    content => template('dar/logrotate.erb'),
  }

}
