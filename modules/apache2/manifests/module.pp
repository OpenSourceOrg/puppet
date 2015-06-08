define apache2::module ($enabled = true) {
  if $enabled {
    exec { "a2enmod_$name":
      command => "a2enmod $name",
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      notify => Service['apache2'],
      unless => "test -e /etc/apache2/mods-enabled/$name.load",
    }
  } else {
    exec { "a2dismod_$name":
      command => "a2dismod $name",
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      notify => Service['apache2'],
      onlyif => "test -e /etc/apache2/mods-enabled/$name.load",
    }
  }
}
