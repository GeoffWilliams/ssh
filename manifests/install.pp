# Ssh::Install
#
# Install SSH server daemon using the default package repository on RedHat or
# the passed in package via a manual hash for AIX and Solaris - intended to be
# used via `include ssh`
#
# @param manual_package Hashed package resource(s) to install on AIX or Solaris.
#   Omitting this variable on these platforms is an error on the user's behalf
#   and the default behaviour is to fail the puppet run with an error in this
#   case
# @package_name Used on RedHat platform to specifiy the package name to install.
#   The default is expected to work without alteration by can be overriden if
#   needed
class ssh::install(
    $manual_package = $ssh::manual_package,
    $package_name   = $ssh::package_name,
) {

  if $manual_package {
    # If packages are required to be manually installed (rpm...) then use hash
    # given to us by user
    if empty($manual_package) {
      fail("To install SSH on ${facts['os']['family']} you must pass hash of the package resources to install")
    } else {
      create_resources("package", $manual_package, {"ensure"=>"present"})
    }
  } else {
    package { $package_name:
      ensure => present,
    }

  }
}
