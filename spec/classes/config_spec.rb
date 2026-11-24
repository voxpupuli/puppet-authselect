# frozen_string_literal: true

require 'spec_helper'

describe 'authselect::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include authselect' }

      before do
        # Fake assert_private function from stdlib to not fail within this test
        Puppet::Parser::Functions.newfunction(:assert_private, type: :rvalue) do |args|
        end
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('authselect set profile') }

      context 'with profile options' do
        let(:pre_condition) do
          <<~PUPPET
            class { 'authselect':
              profile         => 'sssd',
              profile_options => ['with-mkhomedir', 'with-faillock'],
            }
          PUPPET
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_exec('authselect set profile=sssd features=[with-faillock, with-mkhomedir]').with(
            {
              command: ['authselect', 'select', '--force', '--', 'sssd', 'with-faillock', 'with-mkhomedir'],
            },
          )
        }
      end
    end
  end
end
