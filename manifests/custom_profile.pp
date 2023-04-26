# @summary Manage a custom authselect profile
#
# @param contents Custom profile contents use this only if you fully understand how authselect works!
# @param base_profile the profile to base your custom profile off of, defaults to sssd
# @param vendor Specify whether this profile goes into the custom folder or the vendor profile in authselect
#        keep in mind that if you wish to select a custom profile you must prefix the name of the profile
#        with 'custom/' when setting authselect::profile
# @param symlink_meta Symlink meta files from the base profile instead of copying them
# @param symlink_nsswitch Symlink nsswitch files from the base profile instead of copying them
# @param symlink_pam Symlink pam files from the base profile instead of copying them
# @param symlink_dconf Symlink dconf files from the base profile instead of copying them
#
# @example
#   authselect::custom_profile { 'namevar': }
define authselect::custom_profile (
  Hash                                     $contents = {},
  Enum['sssd','winbind', 'nis', 'minimal'] $base_profile = 'sssd',
  Boolean                                  $vendor = false,
  Boolean                                  $symlink_meta = false,
  Boolean                                  $symlink_nsswitch = false,
  Boolean                                  $symlink_pam = false,
  Boolean                                  $symlink_dconf = false,
) {
  include authselect

  $_profile_name = $vendor ? {
    true    => $name,
    default => "custom/${name}",
  }

  $_profile_dir = $vendor ? {
    true    => '/usr/share/authselect/vendor/',
    default => '/etc/authselect/custom',
  }

  $_vendor = $vendor ? {
    true    => ' --vendor',
    default => '',
  }
  $_symlink_meta = $symlink_meta ? {
    true    => ' --symlink-meta',
    default => '',
  }

  $_symlink_nsswitch = $symlink_nsswitch ? {
    true    => ' --symlink-nsswitch',
    default => '',
  }

  $_symlink_pam = $symlink_pam ? {
    true    => ' --symlink-pam',
    default => '',
  }

  $_symlink_dconf = $symlink_dconf ? {
    true    => ' --symlink-dconf',
    default => '',
  }

  exec { "authselect create-profile -b ${base_profile} ${name}":
    path    => ['/usr/bin', '/usr/sbin',],
    command => "authselect create-profile
                 -b ${base_profile} ${name}${_symlink_meta}${_symlink_nsswitch}${_symlink_pam}${symlink_dconf}",
    creates => "${_profile_dir}/${name}",
  }

  $contents.each |$key, $value| {
    authselect::custom_profile_content { "${name}/${key}":
      path => "${_profile_dir}/${name}/${key}",
      *    => $value,
    }
  }

  if $authselect::profile == $_profile_name and defined('Class[authselect::config]') {
    Authselect::Custom_profile[$title] ~> Class['authselect::config']
  }
}
