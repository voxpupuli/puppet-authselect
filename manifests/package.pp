# @summary Manage the authselect package(s)
#
# @example
#   include authselect::package
class authselect::package {
  assert_private()
  package { $authselect::package_names:
    ensure => $authselect::package_ensure,
  }
}
