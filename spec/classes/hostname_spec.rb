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

        describe 'when domainname is not set' do
            it 'should not set resolv.conf search domain' do
                should_not contain_file('resolv.conf search')
            end
            it 'should not set dhclient.conf domain-name' do
                should_not contain_file('dhclient.conf domain')
            end
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

    describe 'when hostname and domainname are set' do
        let(:pre_condition) {
            <<EOS
class ec2init::params {
$hostname = "foo.example.com"
$domainname = "example.com"
}
EOS
        }

        it 'should set resolv.conf search domain' do
            should contain_augeas('resolv.conf search').with(
                'changes'   => [
                    'rm /files/etc/resolv.conf/search/domain',
                    'set /files/etc/resolv.conf/search/domain[1] example.com',
                ]
            )
        end
        it 'should set dhclient.conf domain-name' do
            should contain_file('dhclient.conf domain').with(
                'ensure'    => 'present',
                'path'      => '/etc/dhcp/dhclient.conf',
                'owner'     => 'root',
                'group'     => 'root',
                'mode'      => '0644',
                'content'   => "supersede domain-name \"example.com\";\n"
            )
        end
    end

    describe 'when hostname and domainname are not set' do
        it 'should not set resolv.conf search domain' do
            should_not contain_file('resolv.conf search')
        end
        it 'should not set dhclient.conf domain-name' do
            should_not contain_file('dhclient.conf domain')
        end
    end
end
