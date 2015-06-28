node 'gpl' {
  class { 'opensourceorg::server': }
  class { 'gandi::vm': }

  $domainname = 'opensource.org'

  class { 'postfix':
    domainname    => $domainname,
    destinations  => ["projects.${domainname}", "mail.${domainname}", $domainname],
    use_mailman   => true,
    use_smtp_auth => true,
    use_dkim      => true,
  }

  $mailaliases = hiera('mailaliases')
  $mailaliases.each |$k, $v| {
    mailalias { "$k":
      ensure => present,
      recipient => $v,
      notify => Exec['/usr/bin/newaliases'],
    }
  }
  exec { '/usr/bin/newaliases':
    refreshonly => true
  }

  class { 'mailman':
    emailhost => $domainname,
    webhost => "lists.${domainname}",
  }

  class { 'apache2':
    use_php => true,
  }

  apache2::module { 'cgi': }
  apache2::module { 'rewrite': }
  apache2::module { 'ssl': }
  apache2::virtualhost { "lists.${domainname}":
    shortname => 'lists'
  }

  $sslcerts = hiera('sslcerts')
  $sslcerts.each |$k, $v| {
    ssl::cert { $k:
      cert => $v['cert'],
      key => $v['key'],
    }
  }
}
