node 'gpl' {
  class { 'postfix':
    use_mailman => true
  }
}
