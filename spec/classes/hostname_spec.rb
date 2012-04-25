require 'spec_helper'

describe 'ec2init::hostname' do
    it 'should include params class' do
        should include_class('ec2init::params')
    end

    describe 'when hostname is set' do
        let(:facts) {
            { :ipaddress => '1.2.3.4' }
        }
        let(:pre_condition) {
            'class ec2init::params { $hostname = "foo.example.com" }'
        }

        it 'should configure sysconfig/network' do
            should contain_augeas('sysconfig/network hostname').with(
                'changes' => 'set /files/etc/sysconfig/network/HOSTNAME foo.example.com'
            )
        end
        it 'should set hosts entry' do
            should contain_host('custom fqdn').with(
                'name'  => 'foo.example.com',
                'ip'    => '1.2.3.4'
            )
        end
        it 'should call hostname(1)' do
            should contain_exec('set system hostname').with(
                'command'   => '/bin/hostname foo.example.com',
                'unless'    => '/usr/bin/test `/bin/hostname` = \'foo.example.com\''
            )
        end
    end

    describe 'when hostname is not set' do
        it 'should not configure sysconfig/network' do
            should_not contain_augeas('sysconfig/network hostname')
        end
        it 'should not set hosts entry' do
            should_not contain_host('custom fqdn')
        end
        it 'should not call hostname(1)' do
            should_not contain_exec('set system hostname')
        end
    end
end
