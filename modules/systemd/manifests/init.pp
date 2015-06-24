class systemd {

  package { 'systemd':
    ensure => installed,
  }

  include systemd::journald

}
