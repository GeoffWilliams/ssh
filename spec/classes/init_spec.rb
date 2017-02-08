require 'spec_helper'
describe 'ssh' do
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
      it { should contain_class('ssh') }
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
      it { should contain_class('ssh') }
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
      it { should contain_class('ssh') }
    end
  end
end
