define ssl::cert ($cert, $key) {
  file { "/etc/ssl/certs/$name.pem":
    content => $cert,
    mode => "0644",
  }
  file { "/etc/ssl/private/$name.key":
    content => $key,
    mode => "0600",
  }
}
