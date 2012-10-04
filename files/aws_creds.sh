get_aws_key() {
  cat /etc/sysconfig/aws_creds | awk 'BEGIN { FS = "=" }; /AWS_KEY/  { print $2 }'
}

get_aws_secret() {
  cat /etc/sysconfig/aws_creds | awk 'BEGIN { FS = "=" }; /AWS_SECRET/  { print $2 }'
}

get_aws_token() {
  cat /etc/sysconfig/aws_creds | awk 'BEGIN { FS = "=" }; /AWS_TOKEN/  { print $2 }'
}

