# @summary Configure authselect
#
# @example
#   include authselect::config
class authselect::config {
  assert_private()
  $current_features = $facts['authselect_profile_features'].lest || { [] }.sort
  $requested_features = $authselect::profile_options.sort
  $requested_features_string = $requested_features.join(' ')

  # The command is an array so that it is run without a shell, and the '--'
  # stops the profile and its features from being read as options.
  $select_command = ['authselect', 'select', '--force', '--', $authselect::profile] + $requested_features.filter |$feature| { !$feature.empty }

  # This resource is just used for folks that need deterministic
  # ordering after the package is installed but before authselect is run
  exec { 'authselect set profile':
    path    => ['/usr/bin', '/usr/sbin',],
    command => 'true',
    unless  => 'true',
  }

  if $current_features.join(' ') != $requested_features_string or $facts['authselect_profile'] != $authselect::profile {
    exec { "authselect set profile=${authselect::profile} features=${requested_features}": # lint:ignore:exec_idempotency
      path    => ['/usr/bin', '/usr/sbin',],
      command => $select_command,
      require => Exec['authselect set profile'],
    }
  } else {
    exec { "authselect set profile=${authselect::profile} features=${requested_features}":
      path    => ['/usr/bin', '/usr/sbin',],
      command => $select_command,
      unless  => 'authselect check',
      notify  => Exec['authselect apply-changes'],
      require => Exec['authselect set profile'],
    }
  }

  exec { 'authselect apply-changes':
    path        => ['/usr/bin', '/usr/sbin',],
    refreshonly => true,
  }
}
