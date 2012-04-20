# puppet-ec2init

CloudInit substitute for EC2 bootstrapping using Puppet.

## Why..

### Not CloudInit?

CloudInit doesn't truly support CentOS, yet. It is cumbersome to backport EL6 and morese EL5. It is amazingly complex in places.

### Not Bash?

Bash is not able to, without a lot of manual scaffolding: access meta-data and user-data, aintain SELinux file context labels, and idempotently manage file content, users and services.

### Puppet!

Puppet has a framework for doing all of the above. We already need it pre-installed in our AMIs anyway. It's a darn sight easier to read and write. It's less likely to conflict with our subsequent Puppet runs.

## How

It is a standalone Puppet module and accompanying SysVinit script that is designed to be baked into an AMI and run on every boot. It should bootstrap an otherwise vanilla AMI for subsequent, more fully featured, Puppet runs.

### Default actions

The following actions are performed by default:

- Creates a non-privileged user called `ec2-user`.
- Copies the SSH public key to that user from EC2 meta-data.
- Creates a sudoers rule for that user.
- Disables SSH remote root and password based logins.
- Logs the host's SSH public key fingerprints.

### Additional actions

Additional actions can be triggered by passing JSON content in userdata.

The following actions can be performed:

- Set the instance's hostname.
- Register the hostname in DNS using Route 53.
- Configure `puppet.conf` agent values.

Based on the following JSON:

``` json
{
    "hostname": "foo.bar.example.com",
    "route53": {
        "aws_access_key_id": "XXXXXXXXXXXXXXXXXXXX",
        "aws_secret_access_key": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    },
    "puppet": {
        "server": "puppet.example.com",
        "environment": "bar"
    }
}
```
