# @summary Manage authselect's active profile
#
# This will select the requested authselect profile
#
# @param package_manage
#   Should this class manage the authselect package(s)
# @param package_ensure
#   Passed to `package` `ensure` for the authselect package(s)
# @param package_names
#   Packages to manage in this class
# @param profile_manage
#   Should this class set the active profile
# @param profile
#   Which authselect profile should be used
# @param profile_options
#   What options should we pass to authselect
#   ie, what features should be enabled/disabled?
class authselect (
  Boolean $package_manage,
  String  $package_ensure,
  Array[String[1], 1] $package_names,

  Boolean $profile_manage,
  String[1] $profile,
  Array[String, 0] $profile_options,
) {
  if $package_manage {
    package { $package_names:
      ensure => $package_ensure,
      before => Exec['authselect set profile'],
    }
  }

  if $profile_manage and $package_ensure != 'absent' {
    if $facts['authselect_profile_features'] {
      $current_features = sort($facts['authselect_profile_features'])
    } else {
      $current_features = []
    }
    $requested_features = sort($profile_options)
    $requested_features_string = join($requested_features, ' ')

    if join($current_features, ' ') != $requested_features_string {
      exec { 'authselect set profile':
        path    => ['/usr/bin', '/usr/sbin',],
        command => "authselect select ${profile} ${requested_features_string} --force",
      }
    } else {
      exec { 'authselect set profile':
        path    => ['/usr/bin', '/usr/sbin',],
        command => "authselect select ${profile} ${requested_features_string} --force",
        unless  => 'authselect check',
      }
    }
  } else {
    # stub this out so you can order against it if you need to
    exec { 'authselect set profile':
      path    => ['/usr/bin', '/bin',],
      command => 'true',
      unless  => 'true',
    }
  }
}
