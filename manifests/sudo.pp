class ec2init::sudo {
    include ::ec2init::params

    File {
        owner   => 'root',
        group   => 'root',
    }

    file {
        '/etc/sudoers.d':
            ensure  => directory,
            mode    => '0750';
        '/etc/sudoers.d/ec2':
            ensure  => present,
            mode    => '0440',
            content => template('ec2init/etc/sudoers.d/ec2.erb');
    }
    augeas { 'sudoers includedir':
        changes => [
            'set /files/etc/sudoers/#includedir /etc/sudoers.d',
        ],
        require => [
            File['/etc/sudoers.d/ec2'],
            Class['ec2init::user']
        ],
    }
}
