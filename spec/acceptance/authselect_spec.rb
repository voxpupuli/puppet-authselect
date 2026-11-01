# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'authselect' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        class { 'authselect':
          profile         => 'sssd',
          profile_options => ['with-mkhomedir'],
        }
      PUPPET
    end
  end

  describe package('authselect') do
    it { is_expected.to be_installed }
  end

  describe command('authselect current --raw') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to eq "sssd with-mkhomedir\n" }
  end

  describe command('authselect check') do
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe file('/etc/nsswitch.conf') do
    it { is_expected.to be_symlink }
    its(:content) { is_expected.to match(%r{^passwd:\s.*\bsss\b}) }
  end
end
