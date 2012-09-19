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

    if has_key($userdata, 'route53') and has_key($userdata['route53'], 'aws_access_key_id') and has_key($userdata['route53'], 'aws_secret_access_key') {
        $aws_key = $userdata['route53']['aws_access_key_id']
        $aws_secret = $userdata['route53']['aws_secret_access_key']
    } else {
        warning('Unable to parse route53/aws_access_key_id/aws_secret_access_key from userdata')
        $aws_key = false
        $aws_secret = false
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
