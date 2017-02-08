require 'spec_helper'
describe 'ssh::install' do

  let(:pre_condition) {
    'include ssh'
  }

  #
  # RedHat
  #
  context "RedHat" do
    let :facts do
      {
        :os => {
          :family => "RedHat"
        }
      }
    end

    context 'with default values for all parameters' do
      it { should contain_class('ssh::install') }
    end

    context 'installs correct package' do
      it { should contain_package('openssh-server') }
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
      let :params do
        {
          :manual_package => {
            'openssh' => {
              'source' => '/tmp/packages/openssh-6.6.6-mumrah.rpm',
            }
          }
        }
      end
      it { should contain_class('ssh::install') }
    end

    context 'fails when manual_package not passed' do
      it {
        expect {
          is_expected.to compile.and_raise(Puppet::Error, /must pass hash/)
        }
      }
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
      let :params do
        {
          :manual_package => {
            'openssh' => {
              'source' => '/tmp/packages/openssh-6.6.6,REV=2006.11.18-SunOS5.8-sparc-CSW.pkg',
            }
          }
        }
      end
      it { should contain_class('ssh::install') }
    end

    context 'fails when manual_package not passed' do
      it {
        expect {
          is_expected.to compile.and_raise(Puppet::Error, /must pass hash/)
        }
      }
    end
  end
end
