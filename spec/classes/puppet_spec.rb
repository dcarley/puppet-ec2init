require 'spec_helper'

describe 'ec2init::puppet' do
    it 'should include params class' do
        should include_class('ec2init::params')
    end

    it 'should enable pluginsync and reports' do
        should contain_augeas('puppet.conf agent:defaults').with(
            'changes' => [
                'set /files/etc/puppet/puppet.conf/agent/pluginsync true',
                'set /files/etc/puppet/puppet.conf/agent/report true'
            ]
        )
    end

    describe 'when server present' do
        let(:pre_condition) {
            'class ec2init::params { $puppet_server = "foo.bar" }'
        }
        it 'should set server' do
            should contain_augeas('puppet.conf agent:server').with(
                'changes'   => 'set /files/etc/puppet/puppet.conf/agent/server foo.bar',
                'before'    => 'Exec[puppet agent]'
            )
        end
    end
    describe 'when server is absent' do
        it 'should not set server' do
            should_not contain_augeas('puppet.conf agent:server')
        end
    end

    describe 'when environment is present' do
        let(:pre_condition) {
            'class ec2init::params { $puppet_environment = "foobar" }'
        }
        it 'should set environment' do
            should contain_augeas('puppet.conf agent:environment').with(
                'changes'   => 'set /files/etc/puppet/puppet.conf/agent/environment foobar',
                'before'    => 'Exec[puppet agent]'
            )
        end
    end
    describe 'when environment is absent' do
        it 'should not set environment' do
            should_not contain_augeas('puppet.conf agent:environment')
        end
    end

    it 'should execute puppet agent' do
        should contain_exec('puppet agent').with(
            'command'   => '/usr/bin/puppet agent --onetime &',
            'require'   => [
                'Augeas[puppet.conf agent:defaults]',
                'Class[Ec2init::Hostname]',
            ]
        )
    end
end
