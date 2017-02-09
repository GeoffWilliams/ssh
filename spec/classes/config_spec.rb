require 'spec_helper'
describe 'ssh::config' do

  let(:pre_condition) {
    'include ssh'
  }

  #
  # RedHat
  #
  context "RedHat" do
    let :facts do
      {
        # operatingsystem needed to override host OS when testing on macos :/
        :operatingsystem => "Centos",
        :os => {
          :family => "RedHat"
        }
      }
    end

    context 'with default values for all parameters' do
      it { should contain_class('ssh::config') }
    end

  end
  #
  # AIX
  #
  context "AIX" do
    let :facts do
      {
        :os => {
          :family => "AIX"
        }
      }
    end

    context 'with default values for all parameters' do
      it { should contain_class('ssh::config') }
    end
  end

  #
  # Solaris
  #
  context "Solaris" do
    let :facts do
      {
        :os => {
          :family => "Solaris"
        }
      }
    end

    context 'with default values for all parameters' do
      it { should contain_class('ssh::config') }
    end
  end

  context 'extra_config evaluated correctly' do
    let :facts do
      {
        :os => {
          :family => "RedHat"
        }
      }
    end
    let(:pre_condition) do
      '
      class { "ssh":
        extra_config => {
          "PubkeyAuthentication" => {
            "value"  => "no",
          }
        }
      }
      '
    end
    it { should contain_class('ssh::config') }
    it { should contain_sshd_config("PubkeyAuthentication").with(
      {
        :value => "no",
      }
    )}
  end


  context 'unmanaged entries are not managed' do
    let :facts do
      {
        :os => {
          :family => "RedHat"
        }
      }
    end
    let(:pre_condition) do
      '
      class { "ssh":
        manage_protocol                  => false,
        manage_log_level                 => false,
        manage_x11_forwarding            => false,
        manage_max_auth_tries            => false,
        manage_ignore_rhosts             => false,
        manage_hostbased_authentication  => false,
        manage_permit_root_login         => false,
        manage_permit_empty_passwords    => false,
        manage_permit_user_environment   => false,
        manage_ciphers                   => false,
        manage_client_alive_interval     => false,
        manage_client_alive_count_max    => false,
        manage_banner                    => false,
      }
      '
    end
    it { should contain_class('ssh::config') }

    it { should_not contain_sshd_config("Protocol")}
    it { should_not contain_sshd_config("LogLevel")}
    it { should_not contain_sshd_config("X11Forwarding")}
    it { should_not contain_sshd_config("MaxAuthTries")}
    it { should_not contain_sshd_config("IgnoreRhosts")}
    it { should_not contain_sshd_config("HostbasedAuthentication")}
    it { should_not contain_sshd_config("PermitRootLogin")}
    it { should_not contain_sshd_config("PermitEmptyPasswords")}
    it { should_not contain_sshd_config("PermitUserEnvironment")}
    it { should_not contain_sshd_config("Ciphers")}
    it { should_not contain_sshd_config("ClientAliveCountMax")}
    it { should_not contain_sshd_config("ClientAliveCountMax")}
    it { should_not contain_sshd_config("Banner")}
  end

end
