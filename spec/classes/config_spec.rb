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
end
