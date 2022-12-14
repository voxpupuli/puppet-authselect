# @summary Manage a custom authselect profile
#
# @param contents Custom profile contents
#
# @example
#   authselect::custom_profile { 'namevar': }
define authselect::custom_profile (
  Hash $contents = {},
) {
  include authselect

  exec { "/usr/bin/authselect create-profile -b sssd ${name}":
    creates => "/etc/authselect/custom/${name}",
  }

  $contents.each |$key, $value| {
    authselect::custom_profile_content { "${name}/${key}":
      * => $value,
    }
  }

  if $authselect::profile == "custom/${name}" {
    Authselect::Custom_profile[$title] ~> Class['authselect::config']
  }
}
