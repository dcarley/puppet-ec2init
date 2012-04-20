class ec2init::ddns::stop inherits ec2init::ddns {
    include ::ec2init::params

    if $::ec2init::params::hostname and $::ec2init::params::aws_key and $::ec2init::params::aws_secret {
        Exec['register dynamic dns hostname'] {
            command => "/usr/bin/python /usr/sbin/ec2ddns.py -k ${::ec2init::params::aws_key} -s ${::ec2init::params::aws_secret} ${::ec2init::params::hostname} --delete",
        }
    }
}
