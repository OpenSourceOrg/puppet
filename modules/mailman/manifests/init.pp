class mailman ($emailhost, $webhost) {
  package { 'mailman':
    ensure => present
  }
  service { 'mailman':
    ensure => running,
    require => Package['mailman']
  }

  mailman::configentry { 'DEFAULT_EMAIL_HOST':
    value => "\"$emailhost\""
  }
  mailman::configentry { 'DEFAULT_URL_HOST':
    value => "\"$webhost\""
  }
  mailman::configentry { 'DEFAULT_URL_PATTERN':
    value => "\"https://%s/cgi-bin/mailman/\""
  }
  mailman::configentry { 'MTA':
    value => '"Postfix"'
  }
  mailman::configentry { 'RUNNER_SAVE_BAD_MESSAGES':
    value => 'No'
  }
  mailman::configentry { 'QRUNNER_LOCK_LIFETIME':
    value => 'hours(10)'
  }
  mailman::configentry { 'QRUNNER_PROCESS_LIFETIME':
    value => 'hours(1)'
  }
  mailman::configentry { 'QRUNNER_MAX_MESSAGES':
    value => 3000
  }
}
