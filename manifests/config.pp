# Ssh::Config
#
# Use augeas to rewrite sshd_config file - intended to be used via `include ssh`
class ssh::config(
    $config_file_name           = $ssh::config_file_name,
    $config_file_group          = $ssh::config_file_group,
    $config_file_mode           = $ssh::config_file_mode,

    $manage_service             = $ssh::manage_service,
    $service_title              = $ssh::service_title,
    $service_name               = $ssh::service_name,

    $protocol                   = $ssh::protocol,
    $log_level                  = $ssh::log_level,
    $x11_forwarding             = $ssh::x11_forwarding,
    $max_auth_tries             = $ssh::max_auth_tries,
    $ignore_rhosts              = $ssh::ignore_rhosts,
    $hostbased_authentication   = $ssh::hostbased_authentication,
    $permit_root_login          = $ssh::permit_root_login,
    $permit_empty_passwords     = $ssh::permit_empty_passwords,
    $permit_user_environment    = $ssh::permit_user_environment,
    $ciphers                    = $ssh::ciphers,
    $client_alive_interval      = $ssh::client_alive_interval,
    $client_alive_count_max     = $ssh::client_alive_count_max,
    $banner                     = $ssh::banner,

) {

  file { $config_file_name:
    ensure => file,
    owner  => "root",
    group  => $config_file_group,
    mode   => $config_file_mode,
  }

  # If we have been asked to manage the service then restart it if needed,
  # otherwise sysadmin needs to do this manually
  if $manage_service and $service_name {
    $notify = "Service[${service_title}]"
  } else {
    $notify = undef
  }

  Sshd_config {
    ensure => present,
    notify => $notify,
  }

  sshd_config { "Protocol":
    value => $protocol,
  }

  sshd_config { "LogLevel":
    value => $log_level,
  }

  sshd_config { "X11Forwarding":
    value => $x11_forwarding,
  }

  sshd_config { "MaxAuthTries":
    value => $max_auth_tries,
  }

  sshd_config { "IgnoreRhosts":
    value => $ignore_rhosts,
  }

  sshd_config { "HostbasedAuthentication":
    value => $hostbased_authentication,
  }

  sshd_config { "PermitRootLogin":
    value  => $permit_root_login,
  }

  sshd_config { "PermitEmptyPasswords":
    value  => $permit_empty_passwords,
  }

  sshd_config { "PermitUserEnvironment":
    value  => $permit_user_environment ,
  }

  sshd_config { "Ciphers":
    value  => $ciphers,
  }

  sshd_config { "ClientAliveInterval":
    value  => $client_alive_interval,
  }

  sshd_config { "ClientAliveCountMax":
    value  => $client_alive_count_max,
  }

  sshd_config { "Banner":
    value  => $banner,
  }
}
