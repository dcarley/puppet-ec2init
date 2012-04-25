require 'spec_helper'

%w{ec2init::ddns ec2init::ddns::stop}.each do |klass|
    describe klass do
        it 'should include params class' do
            should include_class('ec2init::params')
        end

        describe 'when all param variables are present and' do
            let(:pre_condition) { <<EOS
class ec2init::params {
$hostname   = 'foo.example.com'
$aws_key    = 'key123'
$aws_secret = 'secret123'
}
EOS
            }

            describe 'when ec2_public_hostname fact is present' do
                let(:facts) {
                    { :ec2_public_hostname => 'ec2.example.com' }
                }

                it 'should install dependencies' do
                    should contain_package('python-boto').with(
                        'ensure'    => 'present'
                    )
                    should contain_package('ec2ddns').with(
                        'ensure'    => 'present',
                        'require'   => 'Package[python-boto]'
                    )
                end

                it 'should execute ec2ddns with arguments' do
                    should contain_exec('register dynamic dns hostname').with(
                        'command'   => case klass
                            when 'ec2init::ddns'
                                '/usr/bin/python /usr/sbin/ec2ddns.py -k key123 -s secret123 foo.example.com ec2.example.com'
                            when 'ec2init::ddns::stop'
                                '/usr/bin/python /usr/sbin/ec2ddns.py -k key123 -s secret123 foo.example.com --delete'
                        end,
                        'require'   => 'Package[ec2ddns]'
                    )
                end
            end
            describe 'when ec2_public_hostname fact is absent' do
                it 'should not execute ec2ddns' do
                    should_not contain_exec('register dynamic dns hostname')
                end
            end
        end

        describe 'when all param variables are absent and' do
            describe 'when ec2_public_hostname fact is present' do
                let(:facts) {
                    { :ec2_public_hostname => 'public_hostname' }
                }

                it 'should not execute ec2ddns' do
                    should_not contain_exec('register dynamic dns hostname')
                end
            end
            describe 'when ec2_public_hostname fact is absent' do
                it 'should not execute ec2ddns' do
                    should_not contain_exec('register dynamic dns hostname')
                end
            end
        end
    end
end
