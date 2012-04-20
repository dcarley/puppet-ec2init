class ec2init::puppet {
    include ::ec2init::params

    augeas { 'puppet.conf agent:defaults':
        changes => [
            'set /files/etc/puppet/puppet.conf/agent/pluginsync true',
            'set /files/etc/puppet/puppet.conf/agent/report true',
        ],
    }

    if $::ec2init::params::puppet_server {
        augeas { 'puppet.conf agent:server':
            changes => [
                "set /files/etc/puppet/puppet.conf/agent/server ${::ec2init::params::puppet_server}",
            ],
        }
    }
    if $::ec2init::params::puppet_environment {
        augeas { 'puppet.conf agent:environment':
            changes => [
                "set /files/etc/puppet/puppet.conf/agent/environment ${::ec2init::params::puppet_environment}",
            ],
        }
    }
}
