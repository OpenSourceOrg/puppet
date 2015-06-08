class standardpackages {
  $pkglist = [
              'moreutils', # Used by mailman::configentry
              'bash-completion',
              'vim-nox',
              'strace',
              'etckeeper',
              ]

  $pkglist.each |$p| {
    package { $p:
      ensure => present
    }
  }
}
