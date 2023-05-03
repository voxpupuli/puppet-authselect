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
#   Which authselect profile should be used.
#   Note: If using a custom (non-vendor) profile you must prefix the name with 'custom/'
# @example Specifying a custom profile
#   authselect::profile: 'custom/custom_profile_name'
# @example Specifying a vendor profile
#    authselect::profile: 'sssd'
# @param profile_options
#   What options should we pass to authselect
#   ie, what features should be enabled/disabled?
# @param custom_profiles
#   Custom profiles to manage
# @example Creating several profiles with different parameters
#   authselect::custom_profiles:
#     'local_user_minimal':
#       base_profile: 'minimal'
#     'local_user_linked_nsswitch':
#       symlink_nsswitch: true
#     'local_user_custom_nsswitch':
#       contents:
#         'nsswitch.conf':
#           content: 'passwd:     files systemd   {exclude if "with-custom-passwd"}
# group:      files systemd   {exclude if "with-custom-group"}
# netgroup:   files           {exclude if "with-custom-netgroup"}
# automount:  files           {exclude if "with-custom-automount"}
# services:   files           {exclude if "with-custom-services"}
# sudoers:    files           {include if "with-sudo"}'
#           ensure: 'file'
#           owner: 'root'
#           group: 'root'
#           mode: '0664'
class authselect (
  Boolean $package_manage,
  String  $package_ensure,
  Array[String[1], 1] $package_names,
  Boolean $profile_manage,
  String[1] $profile,
  Array[String, 0] $profile_options,
  Hash $custom_profiles,
) {
  if $package_manage {
    package { $package_names:
      ensure => $package_ensure,
      before => Exec['authselect set profile'],
    }
  }

  if $profile_manage and $package_ensure != 'absent' {
    include 'authselect::config'
  }

  $custom_profiles.each |$key, $value| {
    authselect::custom_profile { $key:
      * => $value,
    }
  }

  $_selected_profile = "${profile.split('/')[1]}"
  if $_selected_profile in inline_template("<%= custom_profiles.keys %>") and defined('Class[authselect::config]') {
    Authselect::Custom_profile[$_selected_profile] ~> Class['authselect::config']
  }
}
