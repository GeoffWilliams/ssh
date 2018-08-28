# @summary Install and manage ssh daemon with Puppet.
#
# Package installation is determined automatically on RedHat or you may supply a
# valid package name in `package_name`. Where additional information is required
# for package installation (eg location of package file when using rpm directly)
# then this can be passed using `manual_package`. This is a requirement for AIX
# and Solaris.
#
# This module only rewrites the parts the of the `sshd_config` file you tell it to
# in order to preserve defaults/fixes from the vendor. Where explicit
# configuration is required, it should be passed in the `settings` hash.
#
# Augeaus SSH provider is used to perform the re-write of the `sshd_config` file
#
# @see https://forge.puppet.com/herculesteam/augeasproviders_ssh
# @see https://forge.puppet.com/herculesteam/augeasproviders_core
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
#     settings => {
#       "permit_root_login" => "no",
#       "log_level"         => "DEBUG",
#     },
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
# @example Hiera data for some common settings (supported keys are those allowed by ssh itself)
#   ssh::settings:
#     Banner: "/etc/issue.net"
#     Protocol: "2"
#     MaxAuthTries: "4"
#     PermitRootLogin: "no"
#     Ciphers:
#       - "aes128-ctr"
#       - "aes192-ctr"
#       - "aes256-ctr"
#     ClientAliveInterval: "300"
#     ClientAliveCountMax: "1"
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
class ssh(
    String                                      $service_name,
    Boolean                                     $auto_install,
    String                                      $package_name,
    String                                      $config_file_group,
    String                                      $config_file_mode,
    Boolean                                     $manage_package     = true,
    Boolean                                     $manage_service     = true,
    Enum["stopped", "running"]                  $service_ensure     = "running",
    Boolean                                     $service_enable     = true,
    String                                      $config_file_name   = "/etc/ssh/sshd_config",
    Optional[Hash]                              $manual_package     = undef,
    String                                      $service_title      = "sshd",
    Hash[String,Variant[String,Array[String]]]  $settings           = {},
) {


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

  $settings.each |$key, $value| {
    sshd_config { $key:
      value => $value
    }
  }

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
