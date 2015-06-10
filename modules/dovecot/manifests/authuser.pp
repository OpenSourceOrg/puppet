define dovecot::authuser ($password) {
  file { "/etc/dovecot/authusers.d/$title":
    content => "$title:$password\n",
    owner => root,
    group => root,
    mode => '0600',
    require => File['/etc/dovecot/authusers.d'],
    notify => Exec['refresh-dovecot-users']
  }
}
