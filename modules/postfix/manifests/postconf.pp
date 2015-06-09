define postfix::postconf ($value) {
  $key_value = "${name} = ${value}"

  exec { "postconf_${name}":
    command => "postconf -e -M '${key_value}'",
    unless => "test \"\$(postconf -M ${name} | xargs)\" = \"\$(echo ${value} | xargs)\"",
    path => [
             '/usr/bin',
             '/usr/sbin',
             '/bin',
             '/sbin'],
    require => Package['postfix'],
    notify => Service['postfix'],
  }
}
