class opensourceorg::server {
  class { 'debian': }

  class { 'dar': }
  class { 'puppet': }
  class { 'sudo': }
  class { 'syslog': }
  class { 'systemd': }
  class { 'vim': }
}
