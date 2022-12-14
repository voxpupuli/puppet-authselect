# @summary Manage the authselect package(s)
#
# @example
#   include authselect::package
class authselect::package {
  package { $authselect::package_names:
    ensure => $authselect::package_ensure,
  }
}
