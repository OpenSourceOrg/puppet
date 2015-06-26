class opensourceorg::server {
  class { 'debian': }

  class { 'dar': }
  class { 'fail2ban': }
  class { 'puppet': }
  class { 'sudo': }
  class { 'syslog': }
  class { 'systemd': }
  class { 'vim': }
}
