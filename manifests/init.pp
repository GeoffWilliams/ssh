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
    $manage_package             = $ssh::params::manage_package,
    $manage_service             = $ssh::params::manage_service,
    $service_name               = $ssh::params::service_name,
    $service_ensure             = $ssh::params::service_ensure,
    $service_enable             = $ssh::params::service_enable,
    $manual_package             = $ssh::params::manual_package,
    $auto_install               = $ssh::params::auto_install,
    $package_name               = $ssh::params::package_name,

    $config_file_name           = $ssh::params::config_file_name,
    $config_file_group          = $ssh::params::config_file_group,
    $config_file_mode           = $ssh::params::config_file_mode,

    $protocol                   = $ssh::params::protocol,
    $log_level                  = $ssh::params::log_level,
    $x11_forwarding             = $ssh::params::x11_forwarding,
    $max_auth_tries             = $ssh::params::max_auth_tries,
    $ignore_rhosts              = $ssh::params::ignore_rhosts,
    $hostbased_authentication   = $ssh::params::hostbased_authentication,
    $permit_root_login          = $ssh::params::permit_root_login,
    $permit_empty_passwords     = $ssh::params::permit_empty_passwords,
    $permit_user_environment    = $ssh::params::permit_user_environment,
    $ciphers                    = $ssh::params::ciphers,
    $client_alive_interval      = $ssh::params::client_alive_interval,
    $client_alive_count_max     = $ssh::params::client_alive_count_max,
    $banner                     = $ssh::params::banner,
) inherits ssh::params {

  $service_title = "sshd"

  if $manage_package and ($auto_install or ! empty($manual_package)) {
    include ssh::install
  }

  include ssh::config

  if $manage_service and $service_name {
    service { $service_title:
      ensure => $service_ensure,
      name   => $service_name,
      enable => $service_enable,
    }
  }

}
