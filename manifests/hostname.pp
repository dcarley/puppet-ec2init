class ec2init::hostname {
    include ::ec2init::params

    if $::ec2init::params::hostname {
        augeas { 'sysconfig/network hostname':
            changes => "set /files/etc/sysconfig/network/HOSTNAME ${::ec2init::params::hostname}",
        }
        host { 'custom fqdn':
            ensure  => present,
            name    => $::ec2init::params::hostname,
            ip      => $::ipaddress,
        }
        exec { 'set system hostname':
            command => "/bin/hostname ${::ec2init::params::hostname}",
            unless  => "/usr/bin/test `/bin/hostname` = '${::ec2init::params::hostname}'",
        }

        if $::ec2init::params::domainname {
            augeas { 'resolv.conf search':
                changes => [
                    'rm /files/etc/resolv.conf/search/domain',
                    "set /files/etc/resolv.conf/search/domain[1] ${::ec2init::params::domainname}",
                ],
            }
            file { 'dhclient.conf domain':
                ensure  => present,
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                path    => '/etc/dhcp/dhclient.conf',
                content => template('ec2init/etc/dhcp/dhclient.conf.erb'),
            }
        }
    }
}
