# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/authselect_profile'

describe :authselect_profile, type: :fact do
  subject(:fact) { Facter.fact(:authselect_profile) }

  before do
    # perform any action that should be run before every test
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  let(:profile) do
    <<~EOS
      Profile ID: sssd
      Enabled features: None
    EOS
  end

  let(:profile_with_features) do
    <<~EOS
      Profile ID: sssd
      Enabled features:
      - with-pamaccess
      - without-pam-u2f-nouserok
    EOS
  end

  context 'without authselect' do
    before do
      expect(Facter::Util::Resolution).to receive(:which).with('authselect').and_return(nil)
      expect(Facter::Util::Resolution).not_to receive(:exec).with('authselect current')
    end

    it { expect(fact.value).to eq(nil) }
  end

  context 'with authselect, but no profile' do
    before do
      expect(Facter::Util::Resolution).to receive(:which).with('authselect').and_return('authselect')
      expect(Facter::Util::Resolution).to receive(:exec).with('authselect current').and_return('No existing configuration detected.')
    end

    it { expect(fact.value).to eq(nil) }
  end

  context 'with authselect, but profile but no features' do
    before do
      expect(Facter::Util::Resolution).to receive(:which).with('authselect').and_return('authselect')
      expect(Facter::Util::Resolution).to receive(:exec).with('authselect current').and_return(profile)
    end

    it { expect(fact.value).to eq('sssd') }
  end

  context 'with authselect, but profile with features' do
    before do
      expect(Facter::Util::Resolution).to receive(:which).with('authselect').and_return('authselect')
      expect(Facter::Util::Resolution).to receive(:exec).with('authselect current').and_return(profile_with_features)
    end

    it { expect(fact.value).to eq('sssd') }
  end
end
