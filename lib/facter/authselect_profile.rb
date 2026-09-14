# frozen_string_literal: true

require 'yaml'

Facter.add(:authselect_profile) do
  # https://docs.openvoxproject.org/openfact/latest/
  confine kernel: 'Linux'
  confine { Facter::Core::Execution.which('authselect') }

  setcode do
    cmd_out = Facter::Core::Execution.execute('authselect current')
    YAML.safe_load(cmd_out)['Profile ID']
  rescue StandardError
    nil
  end
end
