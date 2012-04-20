class ec2init::user {
    include ::ec2init::params

    File {
        mode    => '0600',
        owner   => $::ec2init::params::ec2_username,
        group   => $::ec2init::params::ec2_username,
    }

    group { $::ec2init::params::ec2_username:
        ensure  => present,
    }
    user { $::ec2init::params::ec2_username:
        ensure      => present,
        gid         => $::ec2init::params::ec2_username,
        groups      => '',
        membership  => 'inclusive',
        managehome  => true,
        require     => Group[$::ec2init::params::ec2_username],
    }
    if $::ec2_public_keys_0_openssh_key {
        file {
            "/home/${::ec2init::params::ec2_username}/.ssh":
                ensure  => directory;
            "/home/${::ec2init::params::ec2_username}/.ssh/authorized_keys":
                ensure  => present,
                content => "${::ec2_public_keys_0_openssh_key}\n";
        }
    } else {
        warning('Unable to get SSH key from ec2_public_keys_0_openssh_key')
    }
}
