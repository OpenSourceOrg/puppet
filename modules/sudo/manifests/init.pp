class sudo ($sudoers = []) {
  package { 'sudo':
    ensure => present
  }
  file { '/etc/sudoers.d/puppet-sudoers':
    content => template('sudo/puppet-sudoers.erb'),
    owner => 'root',
    group => 'root',
    mode => '0440',
  }
}
