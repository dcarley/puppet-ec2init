class ec2init::aws_creds {
  include ::ec2init::params

  #
  # Inject new AWS creds
  #
  augeas { 'aws_creds':
    lens    => "Spacevars.simple_lns",
    incl    => "/etc/sysconfig/aws_creds",
    changes => [
      "set /files/etc/sysconfig/AWS_KEY ${::ec2init::params::aws_key}",
      "set /files/etc/sysconfig/AWS_SECRET ${::ec2init::params::aws_secret}",
      "set /files/etc/sysconfig/AWS_TOKEN ${::ec2init::params::aws_token}",
      "set /files/etc/sysconfig/AWS_EXPIRATION ${::ec2init::params::aws_expiration}",
    ],
  }

  file { "/etc/sysconfig/aws_creds":
    ensure  => file,
    mode    => 700, owner => 'root', group => 'root',
    content => template("ec2init/etc/sysconfig/aws_creds.erb"),
    replace => false,
  }

}
