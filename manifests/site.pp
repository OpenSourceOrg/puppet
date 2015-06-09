node 'gpl' {
  class { 'standardpackages': }

  class { 'postfix':
    use_mailman => false, # Until lists are actually migrated
    destinations => ['projects.opensource.org', 'mail.opensource.org', 'opensource.org']
  }

  class { 'mailman':
    emailhost => 'opensource.org',
    webhost => 'projects.opensource.org'
  }

  class { 'apache2':
    use_php => true,
  }

  apache2::module { 'cgi': }
  apache2::virtualhost { 'gpl.opensource.org':
    shortname => 'gpl'
  }

  apache2::virtualhost { 'opensource.org':
    shortname => 'opensource'
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
}
