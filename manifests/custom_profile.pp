# @summary Manage a custom authselect profile
#
# @param contents Custom profile contents us this only if you fully understand how authselect works!
#
# @example
#   authselect::custom_profile::contents:
#     'nsswitch.conf':
#       content: 'passwd:     sss files systemd   {exclude if "with-custom-passwd"}
# group:      sss files systemd   {exclude if "with-custom-group"}
# netgroup:   sss files           {exclude if "with-custom-netgroup"}
# automount:  sss files           {exclude if "with-custom-automount"}
# services:   sss files           {exclude if "with-custom-services"}
# sudoers:    files sss           {include if "with-sudo"}'
#       ensure: 'file'
#       owner: 'root'
#       group: 'root'
#       mode: '0664'
#
# @param base_profile the profile to base your custom profile off of, defaults to sssd
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
  Boolean                                  $symlink_meta = false,
  Boolean                                  $symlink_nsswitch = false,
  Boolean                                  $symlink_pam = false,
  Boolean                                  $symlink_dconf = false,
) {
  include authselect

  $_symlink_meta = $symlink_meta ? {
    true => ' --symlink-meta',
    default => ''
  }

  $_symlink_nsswitch = $symlink_nsswitch ? {
    true => ' --symlink-nsswitch',
    default => ''
  }

  $_symlink_pam = $symlink_pam ? {
    true => ' --symlink-pam',
    default => ''
  }

  $_symlink_dconf = $symlink_dconf ? {
    true => ' --symlink-dconf',
    default => ''
  }

  exec { "/usr/bin/authselect create-profile -b ${base_profile} ${name}${_symlink_meta}${_symlink_nsswitch}${_symlink_pam}${symlink_dconf}":
    creates => "/etc/authselect/custom/${name}",
  }

  $contents.each |$key, $value| {
    authselect::custom_profile_content { "${name}/${key}":
      profile_name => $name,
      *            => $value,
    }
  }

  if $authselect::profile == "custom/${name}" {
    Authselect::Custom_profile[$title] ~> Class['authselect::config']
  }
}
