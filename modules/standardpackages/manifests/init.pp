class standardpackages {
  package { 'moreutils': # Required for sponge (used in mailman module)
    ensure => present
  }
  package { 'bash-completion':
    ensure => present
  }
  package { 'vim-nox':
    ensure => present
  }
  package { 'strace':
    ensure => present
  }
}
