# frozen_string_literal: true

require 'spec_helper'

describe 'authselect::custom_profile' do
  let(:title) { 'test-profile' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when using defaults' do
        it { is_expected.to compile }

        
        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile').with({
          creates: '/etc/authselect/custom/test-profile'
        }) }
      end

      context 'with vendor' do
        let(:params) do
          {
            'vendor' => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile --vendor').with({
          creates: '/usr/share/authselect/vendor/test-profile'
        }) }
      end

      context 'with symlink_meta' do
        let(:params) do
          {
            'symlink_meta' => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile --symlink-meta').with({
          creates: '/etc/authselect/custom/test-profile'
        }) }
      end

      context 'with symlink_nsswitch' do
        let(:params) do
          {
            'symlink_nsswitch' => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile --symlink-nsswitch').with({
          creates: '/etc/authselect/custom/test-profile'
        }) }
      end

      context 'with symlink_pam' do
        let(:params) do
          {
            'symlink_pam' => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile --symlink-pam').with({
          creates: '/etc/authselect/custom/test-profile'
        }) }
      end

      context 'with symlink_dconf' do
        let(:params) do
          {
            'symlink_dconf' => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile --symlink-dconf').with({
          creates: '/etc/authselect/custom/test-profile'
        }) }
      end

      context 'with all extra options' do
        let(:params) do
          {
            'vendor'           => true,
            'symlink_meta'     => true,
            'symlink_nsswitch' => true,
            'symlink_pam'      => true,
            'symlink_dconf'    => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_exec('authselect create-profile -b sssd test-profile --vendor --symlink-meta --symlink-nsswitch --symlink-pam --symlink-dconf').with({
          creates: '/usr/share/authselect/vendor/test-profile'
        }) }
      end

      context 'with custom contents and no vendor' do
        let(:params) do
          {
            'contents' => {
              'nsswitch.conf' => {
                'content' => 'test'
              }
            },
          }
        end

        it { is_expected.to compile }

        it { is_expected.to create_authselect__custom_profile_content('test-profile/nsswitch.conf').with({
          path: '/etc/authselect/custom/test-profile/nsswitch.conf'
        }) }
      end

      context 'with custom contents and vendor' do
        let(:params) do
          {
            'vendor'   => true,
            'contents' => {
              'nsswitch.conf' => {
                'content' => 'test'
              }
            },
          }
        end

        it { is_expected.to compile }

        it { is_expected.to create_authselect__custom_profile_content('test-profile/nsswitch.conf').with({
          path: '/usr/share/authselect/vendor/test-profile/nsswitch.conf'
        }) }
      end

    end
  end
end
