class postfix ($use_mailman = false) {
  package { 'postfix':
    ensure => present
  }
  service { 'postfix':
    ensure => running,
    require => Package['postfix']
  }

  if $use_mailman {
    $alias_maps = [ 'hash:/etc/aliases, hash:/var/lib/mailman/data/aliases' ]
  } else {
    $alias_maps = [ 'hash:/etc/aliases' ]
  }

  augeas { '/etc/postfix/main.cf-main':
    context => '/files/etc/postfix/main.cf',
    changes => [
                "set alias_maps '$alias_maps'",
                "set alias_database '$alias_maps'",
                "set myorigin /etc/mailname",
                ],
    lens => 'Postfix_Main.lns',
    incl => '/etc/postfix/main.cf',
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file { '/etc/mailname':
    content => "$fqdn\n"
  }
}
