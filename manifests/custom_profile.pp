# @summary Manage a custom authselect profile
#
# @param contents Custom profile contents use this only if you fully understand how authselect works!
# @param base_profile The ID of the profile to base your custom profile on, as shown by `authselect list`.
#        The profiles available differ between OS releases (for example `minimal` on EL9, `local` on EL10).
#        Prefix the ID with `custom/` or `vendor/` to base it on a custom or vendor profile.
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
  Hash    $contents = {},
  Pattern[
    /\A[^\/\s]+\z/,
    /\A(custom|vendor)\/[^\/\s]+\z/
  ]       $base_profile = 'sssd',
  Boolean $vendor = false,
  Boolean $symlink_meta = false,
  Boolean $symlink_nsswitch = false,
  Boolean $symlink_pam = false,
  Boolean $symlink_dconf = false,
) {
  include authselect

  $_profile_name = $vendor ? {
    true    => $name,
    default => "custom/${name}",
  }

  $_profile_dir = $vendor ? {
    true    => '/usr/share/authselect/vendor',
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

  $_authselect_options = "${_vendor}${_symlink_meta}${_symlink_nsswitch}${_symlink_pam}${_symlink_dconf}"

  # The command is an array so that it is run without a shell. Nothing in
  # $base_profile or $name can then be interpreted as shell syntax, and the
  # '--' stops $name from being read as an option.
  $_command = ['authselect', 'create-profile', '-b', $base_profile] + $_authselect_options.strip.split(/\s+/) + ['--', $name]

  exec { "authselect create-profile -b ${base_profile} ${name}${_authselect_options}":
    command => $_command,
    path    => ['/usr/bin', '/usr/sbin',],
    creates => "${_profile_dir}/${name}",
  }

  $contents.each |$key, $value| {
    authselect::custom_profile_content { "${name}/${key}":
      path => "${_profile_dir}/${name}/${key}",
      *    => $value,
    }
  }
}
