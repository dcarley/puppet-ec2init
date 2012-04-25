require 'spec_helper'

describe 'ec2init::user' do
    it 'should include params class' do
        should include_class('ec2init::params')
    end

    let(:pre_condition) {
        'class ec2init::params { $ec2_username = "foo-bar" }'
    }

    it 'should create group' do
        should contain_group('ec2 unprivileged group').with(
            'ensure'    => 'present',
            'name'      => 'foo-bar'
        )
    end
    it 'should create user' do
        should contain_user('ec2 unprivileged user').with(
            'ensure'        => 'present',
            'name'          => 'foo-bar',
            'gid'           => 'foo-bar',
            'groups'        => '',
            'membership'    => 'inclusive'
        )
    end

    describe 'when ssh key is present' do
        let(:facts) {
            { :ec2_public_keys_0_openssh_key => 'foo bar' }
        }

        it 'should create authorized_keys' do
            should contain_file('ec2 unprivileged ~/.ssh').with(
                'ensure'    => 'directory',
                'owner'     => 'foo-bar',
                'group'     => 'foo-bar',
                'mode'      => '0700'
            )
            should contain_file('ec2 unprivileged ~/.ssh/authorized_keys').with(
                'ensure'    => 'present',
                'owner'     => 'foo-bar',
                'group'     => 'foo-bar',
                'mode'      => '0600',
                'content'   => "foo bar\n"
            )
        end
    end
    describe 'when ssh key is absent' do
        it 'should not create authorized_keys' do
            should_not contain_file('ec2 unprivileged ~/.ssh')
            should_not contain_file('ec2 unprivileged ~/.ssh/authorized_keys')
        end
    end
end
