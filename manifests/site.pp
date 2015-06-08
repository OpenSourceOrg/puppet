node 'gpl' {
  class { 'standardpackages': }

  class { 'postfix':
    use_mailman => true,
    destinations => ['projects.opensource.org', 'mail.opensource.org', 'opensource.org']
  }

  class { 'mailman':
    emailhost => 'opensource.org',
    webhost => 'projects.opensource.org'
  }

  class { 'apache2':
    use_php => true,
  }

  apache2::virtualhost { 'gpl.opensource.org':
    shortname => 'gpl'
  }
  apache2::module { 'cgi': }
}
