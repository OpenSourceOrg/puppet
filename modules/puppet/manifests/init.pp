class puppet {
  package { 'puppet':
    ensure => present
  }
  service { 'puppet':
    # we use puppet apply, no need to have the agent running
    ensure => stopped,
    enable => false,
  }
}
