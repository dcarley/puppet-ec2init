module Puppet::Parser::Functions
    newfunction(:parse_iam_creds, :type => :rvalue) do |args|
        unless args.length == 1
            raise Puppet::ParseError, "parse_iam_creds(): Requires one argument, the iam role"
        end

        require 'timeout'
        require 'net/http'
        require 'uri'

        def open(url)
            Net::HTTP.get(URI.parse(url))
        end

        def metadata(role = "")
            begin
                iam_json = open("http://169.254.169.254/latest/meta-data/iam/security-credentials/#{role||=''}")
                PSON.load(iam_json)
            rescue
                Puppet.warning("parse_iam_creds(): Unable to parse JSON from ec2 metadata")
                hash = {}
            end
        end
        begin
            Timeout::timeout(1) { metadata(args[0]) }
        rescue Timeout::Error
            hash = {}
        end
    end
end

