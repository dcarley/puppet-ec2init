module Puppet::Parser::Functions
    newfunction(:parse_userdata, :type => :rvalue) do |args|
        unless args.length == 0
            raise Puppet::ParseError, "parse_userdata(): Requires no arguments"
        end

        begin
            userdata = lookupvar('ec2_userdata')
            hash = PSON.load(userdata)
        rescue
            Puppet.warning("parse_userdata(): Unable to parse JSON from ec2_userdata")
            hash = {}
        end

        hash
    end
end
