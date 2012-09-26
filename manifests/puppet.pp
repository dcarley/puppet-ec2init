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
            changes => "set /files/etc/puppet/puppet.conf/agent/server ${::ec2init::params::puppet_server}",
        }
    }
    if $::ec2init::params::puppet_environment {
        augeas { 'puppet.conf agent:environment':
            changes => "set /files/etc/puppet/puppet.conf/agent/environment ${::ec2init::params::puppet_environment}",
        }
    }
    if $::ec2init::params::puppet_certname{
        augeas { 'puppet.conf agent:certname':
            changes => "set /files/etc/puppet/puppet.conf/agent/certname ${::ec2init::params::puppet_certname}",
        }
    }
    if $::ec2init::params::puppet_ca_server {
        augeas { 'puppet.conf agent:ca_server':
            changes => "set /files/etc/puppet/puppet.conf/agent/ca_server ${::ec2init::params::puppet_ca_server}",
        }
    }

  #
  #  Create workaround crontab entry for http://projects.puppetlabs.com/issues/4680
  #
    cron { "fix_frickin_puppet_4680":
      command     => "/root/workaround_4680.sh",
      user        => root,
      hour        => '*',
      minute      => '*/10',
      environment => [ "PIDDIR=/var/tmp", "LOGDIR=/var/log" ],
      ensure      => present,
    }

    file { "/root/workaround_4680.sh": 
      ensure  => file,
      mode    => 700, owner => 'root', group => 'root', 
      source => 'puppet:///modules/ec2init/workaround_4680.sh',
    }

  #
  #  End of workaround
  #
   
  #
  # Inject AWS creds
  #
    file { "/etc/sysconfig/aws_creds":
      ensure  => file,
      mode    => 700, owner => 'root', group => 'root',
      content => template("ec2init/etc/sysconfig/aws_creds.erb"),
      replace => false,
    }

    cron { "pull_latest_creds":
      command     => '/usr/bin/puppet apply --modulepath /etc/puppet-ec2init --logdest syslog -e "include ::ec2init::aws_creds" > /dev/null',
      user        => root,
      hour        => '00',
      minute      => '*/4',
      environment => [ "MAILTO=ops@sugarinc.com", "PIDDIR=/var/tmp", "LOGDIR=/var/log" ],
      ensure      => present,
    }

    service { 'puppet':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        hasrestart  => true,
        require     => Service['sshd'],
    }
}
