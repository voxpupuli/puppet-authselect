# frozen_string_literal: true

require 'yaml'

Facter.add(:authselect_profile) do
  # https://puppet.com/docs/puppet/latest/fact_overview.html
  confine kernel: 'Linux'
  retval = nil

  setcode do
    if Facter::Util::Resolution.which('authselect')
      begin
        cmd_out = Facter::Util::Resolution.exec('authselect current')
        retval = YAML.safe_load(cmd_out)['Profile ID']
      rescue
        nil
      end
    end
    retval
  end
end
