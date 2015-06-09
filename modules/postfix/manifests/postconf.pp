define postfix::postconf ($type='inet', $private='-', $unpriv='-', $chroot='-', $wakeup='-', $maxproc='-', $command) {
  augeas { "/etc/postfix/master.cf_${name}":
    context => '/files/etc/postfix/master.cf',
    changes => [
                "set $name[type = '$type']/type $type",
                "set $name[type = '$type']/private $private",
                "set $name[type = '$type']/unprivileged $unpriv",
                "set $name[type = '$type']/chroot $chroot",
                "set $name[type = '$type']/wakeup $wakeup",
                "set $name[type = '$type']/limit $maxproc",
                "set $name[type = '$type']/command '$command'",
                ],
    lens => 'Postfix_Master.lns',
    incl => '/etc/postfix/master.cf',
    require => Package['postfix'],
    notify => Service['postfix'],
  }
}
