node 'gpl' {
  class { 'debian': }
  class { 'vim': }

  class { 'postfix':
    use_mailman => true,
    destinations => ['projects.opensource.org', 'mail.opensource.org', 'opensource.org'],
    use_smtp_auth => true,
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
    emailhost => 'opensource.org',
    webhost => 'lists.opensource.org'
  }

  class { 'apache2':
    use_php => true,
  }

  apache2::module { 'cgi': }
  apache2::module { 'rewrite': }
  apache2::module { 'ssl': }
  apache2::virtualhost { 'lists.opensource.org':
    shortname => 'lists'
  }

  $sslcerts = hiera('sslcerts')
  $sslcerts.each |$k, $v| {
    ssl::cert { $k:
      cert => $v['cert'],
      key => $v['key'],
    }
  }

  class { 'sudo': }
  class { 'dar': }
}
