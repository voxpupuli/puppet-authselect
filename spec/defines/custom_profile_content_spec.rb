# frozen_string_literal: true

require 'spec_helper'

describe 'authselect::custom_profile_content' do
  let(:title) { 'testprofile/nsswitch.conf' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when using defaults' do
        let(:params) do
          {
            'content': 'test',
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_file('/etc/authselect/custom/testprofile/nsswitch.conf').with({
          content: 'test'
        })}
      end

      context 'when using the vendor path' do
        let(:params) do 
          {
             'path': '/usr/share/authselect/vendor/testprofile/nsswitch.conf',
             'content': 'test',
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_file('/usr/share/authselect/vendor/testprofile/nsswitch.conf').with({
          content: 'test'
        })}
      end

    end
  end
end
