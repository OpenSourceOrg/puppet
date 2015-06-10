class standardpackages {
  $pkglist = hiera('packages') + hiera('extra_packages')

  $pkglist.each |$p| {
    package { $p:
      ensure => present
    }
  }
}
