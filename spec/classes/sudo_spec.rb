require 'spec_helper'

describe 'ec2init::sudo' do
    it 'should include params class' do
        should include_class('ec2init::params')
    end

    let(:pre_condition) {
        'class ec2init::params { $ec2_username = "foo-bar" }'
    }

    it 'should create sudoers.d entry' do
        should contain_file('/etc/sudoers.d').with(
            'ensure'    => 'directory',
            'mode'      => '0750'
        )
        should contain_file('/etc/sudoers.d/ec2').with(
            'ensure'    => 'present',
            'mode'      => '0440',
            'content'   => /^foo-bar\s/
        )
    end

    it 'should enable sudoers includedir' do
        should contain_augeas('sudoers includedir').with(
            'changes'   => 'set /files/etc/sudoers/#includedir /etc/sudoers.d'
        )
    end
end
