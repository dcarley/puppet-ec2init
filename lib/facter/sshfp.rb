require 'base64'
require 'digest/md5'

# https://gist.github.com/1081110

%w{rsa dsa}.each do |algo|
    Facter.add("ssh#{algo}fp") do
        setcode do
            key = Facter.value("ssh#{algo}key")
            key_decoded = Base64.decode64(key)
            md5 = Digest::MD5.hexdigest(key_decoded)
            md5.scan(/.{1,2}/).join(':')
        end
    end
end
