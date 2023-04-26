# @summary Manage file contents in a custom authselect profile
#
# @param content The file resource `content` attribute
# @param path The full path to the managed file
# @param ensure The file resource `ensure` attribute
# @param owner The file resource `owner` attribute
# @param group The file resource `group` attribute
# @param mode The file resource `mode` attribute
#
# @example
#   authselect::custom_profile_content { 'myprofile/filename':
#     content => "File contents\n",
#   }
define authselect::custom_profile_content (
  String               $content,
  Pattern[
    /(^\/etc\/authselect\/custom\/[^\/]+\/[^\/]+$)|(^\/usr\/share\/authselect\/vendor\/[^\/]+\/[^\/]+$)/
  ]                    $path   = "/etc/authselect/custom/${name}",
  Stdlib::Ensure::File $ensure = 'file',
  String[1]            $owner  = 'root',
  String[1]            $group  = 'root',
  Stdlib::Filemode     $mode   = '0644',
) {
  file { $path:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
  }
}
