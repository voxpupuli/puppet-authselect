# @summary Manage a custom authselect profile
#
# @param contents Custom profile contents use this only if you fully understand how authselect works!
# @param base_profile The ID of the profile to base your custom profile on, as shown by `authselect list`.
#        The profiles available differ between OS releases (for example `minimal` on EL9, `local` on EL10).
#        Prefix the ID with `custom/` to base it on another custom profile. A vendor profile is given by its
#        plain name.
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
  Hash $contents = {},
  Pattern[/\A(custom\/)?[A-Za-z0-9_][A-Za-z0-9._-]*\z/] $base_profile = 'sssd',
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

  $_options = {
    '--vendor'           => $vendor,
    '--symlink-meta'     => $symlink_meta,
    '--symlink-nsswitch' => $symlink_nsswitch,
    '--symlink-pam'      => $symlink_pam,
    '--symlink-dconf'    => $symlink_dconf,
  }.filter |$_option, $enabled| { $enabled }.keys

  # The command is an array so that it is run without a shell, and the '--'
  # stops $name from being read as an option. The title keeps its historical
  # form, with the options after the name.
  exec { (["authselect create-profile -b ${base_profile} ${name}"] + $_options).join(' '):
    command => ['authselect', 'create-profile', '-b', $base_profile] + $_options + ['--', $name],
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
