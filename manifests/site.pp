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
}
