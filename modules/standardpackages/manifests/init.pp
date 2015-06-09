class standardpackages {
  $pkglist = hiera('packages')

  $pkglist.each |$p| {
    package { $p:
      ensure => present
    }
  }
}
