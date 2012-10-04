class ec2init::ddns {
    include ::ec2init::params

    if $::ec2init::params::hostname and $::ec2init::params::aws_key and $::ec2init::params::aws_secret and $::ec2_public_hostname {
        package {
            'python-boto':
                ensure  => present;
        }

        file { "/usr/sbin/ec2ddns.py":
           ensure  => file,
           mode    => 700, owner => 'root', group => 'root',
           source => 'puppet:///modules/ec2init/ec2ddns.py',
           require => Package['python-boto'],
        }

        exec { 'register dynamic dns hostname':
            command => "/usr/bin/python /usr/sbin/ec2ddns.py -k ${::ec2init::params::aws_key} -s ${::ec2init::params::aws_secret} -n ${::ec2init::params::aws_token} ${::ec2init::params::hostname} ${::ec2_public_hostname}",
            require => File['/usr/sbin/ec2ddns.py'],
        }
    }
}
