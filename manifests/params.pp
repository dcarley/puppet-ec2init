class ec2init::params {
    $ec2_username = 'ec2-user'
    $ec2_UID = 502
    $userdata = parse_userdata()

    if has_key($userdata, 'hostname') {
        $hostname = $userdata['hostname']
        $domainname = domain_from_fqdn($hostname)
    } else {
        warning('Unable to parse hostname from userdata')
        $hostname = false
        $domainname = false
    }

    $aws_creds_file = file('/etc/sysconfig/aws_creds')

    $aws_role = inline_template('<%= @aws_creds_file[/AWS_ROLE=(.+?)\n?/,1] %>') ? {
      ""      => has_key($userdata, 'aws_role') ? {
                   true    => $userdata['aws_role'],
                   default => warning('Unable to parse aws_role from userdata'),
      },
      default => inline_template('<%= @aws_creds_file[/AWS_ROLE=(.+?)\n?/,1] %>'),
    }

    $iam_data = parse_iam_creds($aws_role)

    $aws_key = $aws_role ? {
      ""      => "",
      default => $iam_data['AccessKeyId'],
    }

    $aws_secret = $aws_role ? {
      ""      => "",
      default => $iam_data['SecretAccessKey'],
    }

    $aws_token= $aws_role ? {
      ""      => "",
      default => $iam_data['Token'],
    }

    $aws_expiration= $aws_role ? {
      ""      => "",
      default => $iam_data['Expiration'],
    }

    if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'server') {
        $puppet_server = $userdata['puppet']['server']
    } else {
        $puppet_server = false
    }

    if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'environment') {
        $puppet_environment = $userdata['puppet']['environment']
    } else {
        $puppet_environment = false
    }

    if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'ca_server') {
        $puppet_ca_server = $userdata['puppet']['ca_server']
    } else {
        $puppet_ca_server = false
    }

    if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'certname') {
        $puppet_certname = $userdata['puppet']['certname']
    } else {
        $puppet_certname = false
    }
}
