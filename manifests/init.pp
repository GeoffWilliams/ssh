# Ssh
#
# Install and manage ssh daemon with Puppet
#
# @param install Request installation of package
# @param manual_package Manual hash of package resources to install manually on
#   AIX and Solaris
# @param auto_install Can we install automatically or not (without a
#   $manual_packages hash)
class ssh(
    $install        = true,
    $manual_package = $ssh::params::manual_package,
    $auto_install   = $ssh::params::auto_install,
)  inherits ssh::params {

  if $install and ($auto_install or ! empty($manual_package)) {
    include ssh::install
  }

}
