class standardpackages {
  $pkglist = [
              'moreutils', # Used by mailman::configentry
              'bash-completion',
              'vim-nox',
              'strace', # For debugging
              'etckeeper',
              'mutt',
              ]

  $pkglist.each |$p| {
    package { $p:
      ensure => present
    }
  }
}
