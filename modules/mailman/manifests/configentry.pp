define mailman::configentry ($value) {
  $regex = "^$name[ =]"

  exec { "uniquify_mmcfg_$name":
    require => [
                Package['moreutils'],
                Package['mailman'],
                ],
    notify => Service['mailman'],
    command => "awk '{ if (/$regex/) {found++;if (found == 1) print} else {print}} ; END { if (found == 0) print \"$name = \" }' /etc/mailman/mm_cfg.py | sponge /etc/mailman/mm_cfg.py",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    unless => "test $(grep -c '$regex' /etc/mailman/mm_cfg.py) = 1"
  }

  exec { "set_mmcfg_$name":
    command => "sed -i -e 's/$regex.*/$name = $value/' /etc/mailman/mm_cfg.py",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    require => Exec["uniquify_mmcfg_$name"],
    notify => Service['mailman'],
    unless => "grep -q '^$name = $value\$' /etc/mailman/mm_cfg.py"
  }
}
