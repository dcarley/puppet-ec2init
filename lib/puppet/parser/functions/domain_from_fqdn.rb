module Puppet::Parser::Functions
    newfunction(:domain_from_fqdn, :type => :rvalue) do |args|
        unless args.length == 1
            raise Puppet::ParseError, "domain_from_fqdn(): Requires one argument"
        end

        fqdn = args[0].split('.')

        # Discard TLD and gTLDs.
        unless fqdn.length > 2
            return false
        end

        # Strip first part of FQDN.
        domain = fqdn[1..-1]
        domain.join('.')
    end
end
