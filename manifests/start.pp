class ec2init::start {
    include ::ec2init::user
    include ::ec2init::sudo
    include ::ec2init::hostname
    include ::ec2init::ssh
    include ::ec2init::puppet
    include ::ec2init::ddns
}
