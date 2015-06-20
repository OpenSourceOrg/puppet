class dar ($backup_key = undef,
           $backup_dir = undef,
           $log_dir = '/var/log/backup',
           $backup_remote = undef,
           $backup_history = 7)
{

  unless $backup_key {
    fail('backup_key cannot be empty')
  }
  unless $backup_dir {
    fail('backup_dir cannot be empty')
  }
  unless $backup_remote {
    fail('backup_remote should be a non-empty Google Cloud Storage end point, e.g.: gs://something-cool/')
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

  file { '/usr/local/sbin/backup':
    ensure  => present,
    content => template('dar/backup.erb'),
    mode    => '755',
  }
  file { '/usr/local/sbin/backup-catchup':
    ensure  => present,
    content => template('dar/backup-catchup.erb'),
    mode    => '755',
  }
  file { '/usr/local/bin/gsutil':
    ensure  => present,
    content => template('dar/gsutil.erb'),
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
