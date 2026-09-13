# frozen_string_literal: true

require 'yaml'

Facter.add(:authselect_profile) do
  # https://docs.openvoxproject.org/openfact/latest/
  confine kernel: 'Linux'
  retval = nil

  setcode do
    if Facter::Core::Execution.which('authselect')
      begin
        cmd_out = Facter::Core::Execution.execute('authselect current')
        retval = YAML.safe_load(cmd_out)['Profile ID']
      rescue StandardError
        nil
      end
    end
    retval
  end
end
