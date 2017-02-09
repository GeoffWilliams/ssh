# Ssh::Params
#
# Params pattern for ssh module
class ssh::params {
  case $facts['os']['family'] {
    'RedHat': {
      $auto_install       = true
      $manual_package     = undef
      $package_name       = "openssh-server"
      $config_file_group  = "root"
      $config_file_mode   = "0600"
      $service_name       = "sshd"
    }
    'Solaris': {
      $auto_install       = false
      $manual_package     = {}
      $package_name       = undef
      $config_file_group  = "sys"
      $config_file_mode   = "0644"
      $service_name       = "svc:/network/ssh"
    }
    'AIX': {
      $auto_install       = false
      $manual_package     = {}
      $package_name       = undef
      $config_file_group  = "system"
      $config_file_mode   = "0600"
      $service_name       = "sshd"
    }
    default: {
      fail("Module ${module_name} does not support ${facts['os']['family']}")
    }
  }

  $manage_package             = true
  $manage_service             = true
  $service_ensure             = running
  $service_enable             = true

  $config_file_name           = "/etc/ssh/sshd_config"

  # default rule settings same for all platforms
  $protocol                   = "2"
  $log_level                  = "INFO"
  $x11_forwarding             = "no"
  $max_auth_tries             = "4"
  $ignore_rhosts              = "yes"
  $hostbased_authentication   = "no"
  $permit_root_login          = "no"
  $permit_empty_passwords     = "no"
  $permit_user_environment    = "no"
  $ciphers                    = ["aes128-ctr", "aes192-ctr", "aes256-ctr"]
  $client_alive_interval      = "300"
  $client_alive_count_max     = "1"
  $banner                     = "/etc/issue.net"


}
