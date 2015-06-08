node 'gpl' {
  class { 'standardpackages': }

  class { 'postfix':
    use_mailman => true,
    destinations => ['projects.opensource.org', 'mail.opensource.org']
  }

  class { 'mailman': }
}
