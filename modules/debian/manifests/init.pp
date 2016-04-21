class debian {
  $pkglist = hiera('packages') + hiera('extra_packages')

  $pkglist.each |$p| {
    package { $p:
      ensure => present
    }
  }

  include debian::unattended_upgrades
  include debian::local_apt_repository
}
