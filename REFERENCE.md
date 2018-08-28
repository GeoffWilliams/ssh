# Reference

## Classes

* [`ssh`](#ssh): Install and manage ssh daemon with Puppet.

## Classes

### ssh

Package installation is determined automatically on RedHat or you may supply a
valid package name in `package_name`. Where additional information is required
for package installation (eg location of package file when using rpm directly)
then this can be passed using `manual_package`. This is a requirement for AIX
and Solaris.

This module only rewrites the parts the of the `sshd_config` file you tell it to
in order to preserve defaults/fixes from the vendor. Where explicit
configuration is required, it should be passed in the `settings` hash.

Augeaus SSH provider is used to perform the re-write of the `sshd_config` file

* **See also**
https://forge.puppet.com/herculesteam/augeasproviders_ssh
https://forge.puppet.com/herculesteam/augeasproviders_core

#### Examples

##### Install SSH server using the defaults

```puppet
include ssh
```

##### Configure SSH server but don't perform any software installation

```puppet
class { "ssh":
  manage_package => false,
}
```

##### Install and configure SSH server but don't touch the service

```puppet
class { "ssh":
  manage_service => false,
}
```

##### Install and configure SSH server but disable root logins and enable debug logging

```puppet
class { "ssh":
  settings => {
    "permit_root_login" => "no",
    "log_level"         => "DEBUG",
  },
}
```

##### Install and configure SSH server on AIX

```puppet
class { "ssh":
  manual_package => {
    "provider"     => "rpm",
    "package_name" => "megacorp_ssh",
    "source"       => "/tmp/megacorp_ssh.rpm"
  },
}
```

##### Hiera data for some common settings (supported keys are those allowed by ssh itself)

```puppet
ssh::settings:
  Banner: "/etc/issue.net"
  Protocol: "2"
  MaxAuthTries: "4"
  PermitRootLogin: "no"
  Ciphers:
    - "aes128-ctr"
    - "aes192-ctr"
    - "aes256-ctr"
  ClientAliveInterval: "300"
  ClientAliveCountMax: "1"
```

#### Parameters

The following parameters are available in the `ssh` class.

##### `manage_package`

Data type: `Boolean`

`true` to manage package installation otherwise false

Default value: `true`

##### `manage_service`

Data type: `Boolean`

`true` to manage the service otherwise false

Default value: `true`

##### `service_name`

Data type: `String`

name of the SSH service on this system

##### `service_ensure`

Data type: `Enum["stopped", "running"]`

State to ensure the ssh service to

Default value: "running"

##### `service_enable`

Data type: `Boolean`

`true` to enable the service on boot, `false` to leave
it alone

Default value: `true`

##### `manual_package`

Data type: `Optional[Hash]`

Hash of additional properties for the `package`
resource. Required on AIX and Solaris

Default value: `undef`

##### `auto_install`

Data type: `Boolean`

`true` if we can install automatically without having to
specify package details manually. Normally autodetected

##### `package_name`

Data type: `String`

Name of package to install. On Solaris and AIX, you must
ensure the name you supply here matches that described in any package file
you try to install in order to avoid idempotency errors when puppet cant
detect that the package has already been installed

##### `config_file_name`

Data type: `String`

Full path of SSHD config file to write

Default value: "/etc/ssh/sshd_config"

##### `config_file_group`

Data type: `String`

Group ownership for SSHD config file

##### `config_file_mode`

Data type: `String`

Permissions for SSHD config file

##### `manage_service`

True if we should manage the SSHD service with Puppet

Default value: `true`

##### `service_name`

Name of the SSHD service on this system

##### `service_title`

Data type: `String`



Default value: "sshd"

##### `settings`

Data type: `Hash[String,Variant[String,Array[String]]]`



Default value: {}

