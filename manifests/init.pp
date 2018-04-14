# Install and manage ssh daemon with Puppet.
#
# Package installation is determined automatically on RedHat or you may supply a
# valid package name in `package_name`. Where additional information is required
# for package installation (eg location of package file when using rpm directly)
# then this can be passed using `manual_package`. This is a requirement for AIX
# and Solaris.
#
# Where configuration away from the defaults in this module is required, you may
# choose to edit/not edit particular directives in the sshd_config config file
# (uses Augeas). Note that this is an in-place edit and will preserve any
# existing content that is not required to be changed.
#
# @example Install SSH server using the defaults
#   include ssh
#
# @example Configure SSH server but don't perform any software installation
#   class { "ssh":
#     manage_package => false,
#   }
#
# @example Install and configure SSH server but don't touch the service
#   class { "ssh":
#     manage_service => false,
#   }
#
# @example Install and configure SSH server but disable root logins and enable debug logging
#   class { "ssh":
#     permit_root_login => "no",
#     log_level         => "DEBUG",
#   }
#
# @example Install and configure SSH server on AIX
#   class { "ssh":
#     manual_package => {
#       "provider"     => "rpm",
#       "package_name" => "megacorp_ssh",
#       "source"       => "/tmp/megacorp_ssh.rpm"
#     },
#   }
#
# @param manage_package `true` to manage package installation otherwise false
# @param manage_service `true` to manage the service otherwise false
# @param service_name name of the SSH service on this system
# @param service_ensure State to ensure the ssh service to
# @param service_enable `true` to enable the service on boot, `false` to leave
#   it alone
# @param manual_package Hash of additional properties for the `package`
#   resource. Required on AIX and Solaris
# @param auto_install `true` if we can install automatically without having to
#   specify package details manually. Normally autodetected
# @param package_name Name of package to install. On Solaris and AIX, you must
#   ensure the name you supply here matches that described in any package file
#   you try to install in order to avoid idempotency errors when puppet cant
#   detect that the package has already been installed
# @param config_file_name Full path of SSHD config file to write
# @param config_file_group Group ownership for SSHD config file
# @param config_file_mode Permissions for SSHD config file
# @param manage_service True if we should manage the SSHD service with Puppet
# @param service_name Name of the SSHD service on this system
# @param protocol `protocol` parameter to write to config file
# @param manage_protocol `true` to manage the `protocol` line in config file
#   otherwise leave alone
# @param log_level `log_level` parameter to write to config file
# @param manage_log_level `true` to manage `log_level` in config file otherwise
#   leave alone
# @param x11_forwarding `x11_forwarding` value for config file
# @param manage_x11_forwarding `true` to manage `x11_forwarding` in config file
#   otherwise leave alone
# @param max_auth_tries `max_auth_tries` value for config file
# @param manage_max_auth_tries `true` to manage `max_auth_tries` in config file
#   otherwise leave alone
# @param ignore_rhosts `ignore_rhosts` value for config file
# @param manage_ignore_rhosts `true` to manage `ignore_rhosts` in config file
#   otherwise leave alone
# @param hostbased_authentication `hostbased_authentication` value for config file
# @param manage_hostbased_authentication `true` to manage
#   `hostbased_authentication` in config file otherwise leave alone
# @param permit_root_login value for `permit_root_login` in config file
# @param manage_permit_root_login `true` to manage `permit_root_login` in config
#   file otherwise leave alone
# @param permit_empty_passwords value for `permit_empty_passwords` in config
#   file
# @param manage_permit_empty_passwords `true` to manage `permit_empty_passwords`
#   in config file otherwise leave alone
# @param permit_user_environment value for `permit_user_environment` in config
#   file
# @param manage_permit_user_environment `true` to manage
#   `permit_user_environment` in config file otherwise leave alone
# @param ciphers value for `ciphers` in config file
# @param manage_ciphers `true` to manage `ciphers` in config file otherwise
#   leave alone
# @param client_alive_interval value for `client_alive_interval` in config file
# @param manage_client_alive_interval `true` to manage `client_alive_interval`
#   in config file otherwise leave alone
# @param client_alive_count_max value for `client_alive_count_max` in config
#   file
# @param manage_client_alive_count_max `true` to manage `client_alive_count_max`
#   in config file otherwise leave alone
# @param banner value for `banner` in config file
# @param manage_banner `true` to manage `banner` in config file otherwise leave
#   alone
# @param extra_config hash of extra configuration to add to the config file, in
#   a form suitable for `create_resources("sshd_config", $extra_config)`
class ssh(
    Boolean $manage_package                     = $ssh::params::manage_package,
    Boolean $manage_service                     = $ssh::params::manage_service,
    String $service_name                        = $ssh::params::service_name,
    Enum["stopped", "running"] $service_ensure  = $ssh::params::service_ensure,
    Boolean $service_enable                     = $ssh::params::service_enable,
    Optional[Hash] $manual_package              = undef,
    Boolean $auto_install                       = $ssh::params::auto_install,
    String $package_name                        = $ssh::params::package_name,

    String $config_file_name                    = $ssh::params::config_file_name,
    String $config_file_group                   = $ssh::params::config_file_group,
    String $config_file_mode                    = $ssh::params::config_file_mode,
    String $protocol                            = $ssh::params::protocol,
    Boolean $manage_protocol                    = true,
    String $log_level                           = $ssh::params::log_level,
    Boolean $manage_log_level                   = true,
    Enum["yes", "no"] $x11_forwarding           = $ssh::params::x11_forwarding,
    Boolean $manage_x11_forwarding              = true,
    String $max_auth_tries                      = $ssh::params::max_auth_tries,
    Boolean $manage_max_auth_tries              = true,
    Enum["yes", "no"] $ignore_rhosts            = $ssh::params::ignore_rhosts,
    Boolean $manage_ignore_rhosts               = true,
    Enum["yes", "no"] $hostbased_authentication = $ssh::params::hostbased_authentication,
    Boolean $manage_hostbased_authentication    = true,
    Enum["yes", "no"] $permit_root_login        = $ssh::params::permit_root_login,
    Boolean $manage_permit_root_login           = true,
    Enum["yes", "no"] $permit_empty_passwords   = $ssh::params::permit_empty_passwords,
    Boolean $manage_permit_empty_passwords      = true,
    Enum["yes", "no"] $permit_user_environment  = $ssh::params::permit_user_environment,
    Boolean $manage_permit_user_environment     = true,
    Array[String] $ciphers                      = $ssh::params::ciphers,
    Boolean $manage_ciphers                     = true,
    String $client_alive_interval               = $ssh::params::client_alive_interval,
    Boolean $manage_client_alive_interval       = true,
    String $client_alive_count_max              = $ssh::params::client_alive_count_max,
    Boolean $manage_client_alive_count_max      = true,
    String $banner                              = $ssh::params::banner,
    Boolean $manage_banner                      = true,
    Hash $extra_config                          = {},
) inherits ssh::params {

  $service_title = "sshd"

  if $manage_package {
    # must specify all the details for $manual_package if used
    if ! $auto_install and empty($manual_package) {
      fail("To install SSH on ${facts['os']['family']} you must pass hash of the package resources to install")
    } else {
      package { $package_name:
        * => {"ensure" => "present"} + pick($manual_package, {}),
      }
    }
  }

  file { $config_file_name:
    ensure => file,
    owner  => "root",
    group  => $config_file_group,
    mode   => $config_file_mode,
  }

  # If we have been asked to manage the service then restart it if needed,
  # otherwise sysadmin needs to do this manually
  if $manage_service and $service_name {
    $notify = Service[$service_title]
  } else {
    $notify = undef
  }

  Sshd_config {
    ensure => present,
    notify => $notify,
  }

  if $manage_protocol {
    sshd_config { "Protocol":
      value => $protocol,
    }
  }

  if $manage_log_level {
    sshd_config { "LogLevel":
      value => $log_level,
    }
  }

  if $manage_x11_forwarding {
    sshd_config { "X11Forwarding":
      value => $x11_forwarding,
    }
  }

  if $manage_max_auth_tries {
    sshd_config { "MaxAuthTries":
      value => $max_auth_tries,
    }
  }

  if $manage_ignore_rhosts {
    sshd_config { "IgnoreRhosts":
      value => $ignore_rhosts,
    }
  }

  if $manage_hostbased_authentication {
    sshd_config { "HostbasedAuthentication":
      value => $hostbased_authentication,
    }
  }

  if $manage_permit_root_login {
    sshd_config { "PermitRootLogin":
      value  => $permit_root_login,
    }
  }

  if $manage_permit_empty_passwords {
    sshd_config { "PermitEmptyPasswords":
      value  => $permit_empty_passwords,
    }
  }

  if $manage_permit_user_environment {
    sshd_config { "PermitUserEnvironment":
      value  => $permit_user_environment ,
    }
  }

  if $manage_ciphers {
    sshd_config { "Ciphers":
      value  => $ciphers,
    }
  }

  if $manage_client_alive_interval {
    sshd_config { "ClientAliveInterval":
      value  => $client_alive_interval,
    }
  }

  if $manage_client_alive_count_max {
    sshd_config { "ClientAliveCountMax":
      value  => $client_alive_count_max,
    }
  }

  if $manage_banner {
    sshd_config { "Banner":
      value  => $banner,
    }
  }

  # create any user supplied
  create_resources("sshd_config", $extra_config)

  # we always create Service[sshd] mananging the appropriate service to allow
  # other users of this module to refer to a consistent service name
  if $manage_service and $service_name {
    service { $service_title:
      ensure => $service_ensure,
      name   => $service_name,
      enable => $service_enable,
    }
  }

}
