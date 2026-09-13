# frozen_string_literal: true

require 'yaml'

Facter.add(:authselect_profile_features) do
  # https://docs.openvoxproject.org/openfact/latest/
  confine kernel: 'Linux'
  confine { Facter::Core::Execution.which('authselect') }

  setcode do
    cmd_out = Facter::Core::Execution.execute('authselect current')
    retval = YAML.safe_load(cmd_out)['Enabled features']
    retval = [] if retval == 'None'
    retval
  rescue StandardError
    nil
  end
end
