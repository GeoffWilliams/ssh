# @PDQTest

# Test manual installation to simulate AIX (and somewhat solaris). We can't
# manage the service since the dummy package doesn't provide one ;-)
class { "ssh":
  auto_install   => false,
  package_name   => "dummy_ssh",
  manage_service => false,
  manual_package => {
    provider => "rpm",
    source   => "/testcase/spec/mock/dummy_ssh-1.0.0-0.x86_64.rpm",
  },
}
