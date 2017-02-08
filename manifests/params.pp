# Ssh::Params
#
# Params pattern for ssh module
class ssh::params {
  case $facts['os']['family'] {
    'RedHat': {
      $auto_install   = true
      $manual_package = undef
      $package_name   = "openssh"
    }
    'Solaris': {
      $auto_install   = false
      $manual_package = {}
      $package_name   = undef
    }
    'AIX': {
      $auto_install   = false
      $manual_package = {}
      $package_name   = undef
    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['family']}")
    }
  }

}
