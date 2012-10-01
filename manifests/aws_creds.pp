class ec2init::aws_creds {
  include ::ec2init::params

  #
  # Inject new AWS creds
  #
  augeas { 'aws_creds':
    lens    => "Shellvars.lns",
    incl    => "/etc/sysconfig/aws_creds",
    changes => [
      "set AWS_KEY  ${::ec2init::params::aws_key}",
      "set AWS_SECRET ${::ec2init::params::aws_secret}",
      "set AWS_TOKEN ${::ec2init::params::aws_token}",
      "set AWS_EXPIRATION ${::ec2init::params::aws_expiration}",
    ],
  }

}
