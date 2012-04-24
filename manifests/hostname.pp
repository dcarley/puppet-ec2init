class ec2init::hostname {
    include ::ec2init::params

    if $::ec2init::params::hostname {
        augeas { 'sysconfig/network hostname':
            changes => "set /files/etc/sysconfig/network/HOSTNAME ${::ec2init::params::hostname}",
        }
        host { $::ec2init::params::hostname:
            ensure  => present,
            ip      => $::ipaddress,
        }
        exec { 'set system hostname':
            command => "/bin/hostname ${::ec2init::params::hostname}",
            unless  => "/usr/bin/test `/bin/hostname` = '${::ec2init::params::hostname}'",
        }
    }
}
