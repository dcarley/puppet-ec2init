class ec2init::ssh {
    notice("SSH RSA: ${::sshrsafp}")
    notice("SSH DSA: ${::sshdsafp}")

    augeas { 'sshd_config hardening':
        changes => [
            'set /files/etc/ssh/sshd_config/PermitRootLogin no',
            'set /files/etc/ssh/sshd_config/PasswordAuthentication no',
        ],
        require     => File['ec2 unprivileged ~/.ssh/authorized_keys'],
    }
    service { 'sshd':
        ensure      => running,
        enable      => true,
        hasstatus   => true,
        hasrestart  => true,
        subscribe   => Augeas['sshd_config hardening'],
    }
}
