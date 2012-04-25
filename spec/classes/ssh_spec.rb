require 'spec_helper'

describe 'ec2init::ssh' do
    it 'should harden sshd_config' do
        should contain_augeas('sshd_config hardening').with(
            'changes' => [
                'set /files/etc/ssh/sshd_config/PermitRootLogin no',
                'set /files/etc/ssh/sshd_config/PasswordAuthentication no'
            ]
        )
    end
    it 'should subscribe sshd service' do
        should contain_service('sshd').with(
            'ensure'        => 'running',
            'enable'        => 'true',
            'hasstatus'     => 'true',
            'hasrestart'    => 'true',
            'subscribe'     => 'Augeas[sshd_config hardening]'
        )
    end
end
