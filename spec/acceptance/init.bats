# BATS test file to run after executing 'examples/init.pp' with puppet.
#
# For more info on BATS see https://github.com/sstephenson/bats

# Tests are really easy! just the exit status of running a command...
@test "Protocol" {
  grep "Protocol 2" /etc/ssh/sshd_config
}

@test "LogLevel" {
  grep "LogLevel INFO" /etc/ssh/sshd_config
}

@test "X11Forwarding" {
  grep "X11Forwarding no" /etc/ssh/sshd_config
}

@test "MaxAuthTries" {
  grep "MaxAuthTries 3" /etc/ssh/sshd_config
}

@test "IgnoreRhosts" {
  grep "IgnoreRhosts yes" /etc/ssh/sshd_config
}

@test "HostbasedAuthentication" {
  grep "HostbasedAuthentication no" /etc/ssh/sshd_config
}

@test "PermitRootLogin" {
  grep "PermitRootLogin no" /etc/ssh/sshd_config
}

@test "PermitEmptyPasswords" {
  grep "PermitEmptyPasswords no" /etc/ssh/sshd_config
}

@test "PermitUserEnvironment" {
  grep "PermitUserEnvironment no" /etc/ssh/sshd_config
}

@test "Ciphers" {
  grep "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" /etc/ssh/sshd_config
}

@test "ClientAliveInterval" {
  grep "ClientAliveInterval 300" /etc/ssh/sshd_config
}

@test "ClientAliveCountMax" {
  grep "ClientAliveCountMax 1" /etc/ssh/sshd_config
}

@test "Banner" {
  grep "Banner /etc/issue.net" /etc/ssh/sshd_config
}
