class vim {
  package { 'vim-nox':
    ensure => present,
  }

  file { '/etc/vim/vimrc.local':
    ensure  => present,
    content => template('vim/vimrc.local.erb'),
  }
}
