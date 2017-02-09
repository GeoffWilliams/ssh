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


end
