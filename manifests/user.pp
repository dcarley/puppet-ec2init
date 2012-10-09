class ec2init::user {
    include ::ec2init::params

    File {
        owner   => $::ec2init::params::ec2_username,
        group   => $::ec2init::params::ec2_username,
    }

    group { 'ec2 unprivileged group':
        ensure  => present,
        name    => $::ec2init::params::ec2_username,
    }
    user { 'ec2 unprivileged user':
        ensure      => present,
        name        => $::ec2init::params::ec2_username,
        gid         => $::ec2init::params::ec2_username,
        uid         => $::ec2init::params::ec2_UID,
        groups      => [ ],
        membership  => 'inclusive',
        managehome  => true,
        require     => Group['ec2 unprivileged group'],
    }
    if $::ec2_public_keys_0_openssh_key {
        file {
            'ec2 unprivileged ~/.ssh':
                ensure  => directory,
                path    => "/home/${::ec2init::params::ec2_username}/.ssh",
                mode    => '0700',
                require => User['ec2 unprivileged user'];
            'ec2 unprivileged ~/.ssh/authorized_keys':
                ensure  => present,
                path    => "/home/${::ec2init::params::ec2_username}/.ssh/authorized_keys",
                mode    => '0600',
                content => "${::ec2_public_keys_0_openssh_key}\n";
        }
    } else {
        warning('Unable to get SSH key from ec2_public_keys_0_openssh_key')
    }
}
