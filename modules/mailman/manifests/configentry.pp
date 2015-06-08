define mailman::configentry ($value) {
  $regex = "^$name[ =].*"
  $file = "/etc/mailman/mm_cfg.py"

  exec { "uniquify_mmcfg_$name":
    require => [
                Package['moreutils'],
                Package['mailman'],
                ],
    notify => Service['mailman'],
    command => "awk '{ if (/$regex/) {found++;if (found == 1) print} else {print}} ; END { if (found == 0) print \"$name = \" }' $file | sponge $file",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    unless => "test $(grep -c '$regex' $file) = 1"
  }

  exec { "set_mmcfg_$name":
    command => "sed -i -e 's/$regex/$name = $value/' $file",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    require => Exec["uniquify_mmcfg_$name"],
    notify => Service['mailman'],
    unless => "grep -F -q -x '$name = $value' $file"
  }
}
