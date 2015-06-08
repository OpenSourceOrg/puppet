define apache2::virtualhost ($shortname, $enabled = true) {
  if $enabled {
    file { "/var/www/$shortname":
      ensure => directory
    }
    file { "/var/www/$shortname/public":
      ensure => directory
    }
    file { "/var/www/$shortname/logs":
      ensure => directory
    }
    exec { "a2ensite_$name":
      command => "a2ensite $name.conf",
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      notify => Service['apache2'],
      unless => "test -e /etc/apache2/sites-enabled/$name.conf",
      require => File["/etc/apache2/sites-available/$name.conf"]
    }
    file { "/etc/apache2/sites-available/$name.conf":
      ensure => present,
      source => "puppet:///modules/apache2/$name.conf"
    }
  } else {
    exec { "a2dissite_$name":
      command => "a2dissite $name.conf",
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      notify => Service['apache2'],
      onlyif => "test -e /etc/apache2/sites-enabled/$name.conf"
    }
  }
}
