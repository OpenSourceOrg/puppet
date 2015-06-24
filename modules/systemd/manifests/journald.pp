class systemd::journald (
  $persistent_logging = true,
  $system_max_use = '1G'
) {

  if $persistent_logging {
    # see /usr/share/doc/systemd/README.Debian for details about enabling
    # persistent logging with journald

    file { '/var/log/journal':
      ensure => directory,
      owner  => 'root',
      group  => 'systemd-journal',
      mode   => '2755',
      notify => Exec['/var/log/journal-setfacl'],
    }

    exec { '/var/log/journal-setfacl':
      command     => "setfacl -R -nm g:adm:rx,d:g:adm:rx /var/log/journal",
      path        => ['/usr/bin', '/bin'],
      refreshonly => true,
      unless      => "getfacl /var/log/journal/ | grep ^default:group:adm:r-x && getfacl /var/log/journal/ | grep ^group:adm:r-x",
    }

  }

  file { '/etc/systemd/journald.conf':
    ensure  => present,
    content => template('systemd/journald.conf.erb'),
  }

}
