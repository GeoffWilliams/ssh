# @PDQTest
class { "ssh":
  settings => {
    "Banner"              => "/etc/issue.net",
    "Protocol"            => "2",
    "MaxAuthTries"        => "4",
    "PermitRootLogin"     => "no",
    "Ciphers"             => ["aes128-ctr","aes192-ctr","aes256-ctr"],
    "ClientAliveInterval" => "300",
    "ClientAliveCountMax" => "1",
  }
}