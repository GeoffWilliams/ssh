# Ssh::Config
#
# Use augeas to rewrite sshd_config file - intended to be used via `include ssh`
class ssh::config(
    $config_file_name                 = $ssh::config_file_name,
    $config_file_group                = $ssh::config_file_group,
    $config_file_mode                 = $ssh::config_file_mode,

    $manage_service                   = $ssh::manage_service,
    $service_title                    = $ssh::service_title,
    $service_name                     = $ssh::service_name,

    $protocol                         = $ssh::protocol,
    $manage_protocol                  = $ssh::manage_protocol,
    $log_level                        = $ssh::log_level,
    $manage_log_level                 = $ssh::manage_log_level,
    $x11_forwarding                   = $ssh::x11_forwarding,
    $manage_x11_forwarding            = $ssh::manage_x11_forwarding,
    $max_auth_tries                   = $ssh::max_auth_tries,
    $manage_max_auth_tries            = $ssh::manage_max_auth_tries,
    $ignore_rhosts                    = $ssh::ignore_rhosts,
    $manage_ignore_rhosts             = $ssh::manage_ignore_rhosts,
    $hostbased_authentication         = $ssh::hostbased_authentication,
    $manage_hostbased_authentication  = $ssh::manage_hostbased_authentication,
    $permit_root_login                = $ssh::permit_root_login,
    $manage_permit_root_login         = $ssh::manage_permit_root_login,
    $permit_empty_passwords           = $ssh::permit_empty_passwords,
    $manage_permit_empty_passwords    = $ssh::manage_permit_empty_passwords,
    $permit_user_environment          = $ssh::permit_user_environment,
    $manage_permit_user_environment   = $ssh::manage_permit_user_environment,
    $ciphers                          = $ssh::ciphers,
    $manage_ciphers                   = $ssh::manage_ciphers,
    $client_alive_interval            = $ssh::client_alive_interval,
    $manage_client_alive_interval     = $ssh::manage_client_alive_interval,
    $client_alive_count_max           = $ssh::client_alive_count_max,
    $manage_client_alive_count_max    = $ssh::manage_client_alive_count_max,
    $banner                           = $ssh::banner,
    $manage_banner                    = $ssh::manage_banner,

    $extra_config                     = $ssh::extra_config,
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

  # create any user supplie d
  create_resources("sshd_config", $extra_config)
}
