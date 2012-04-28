require 'spec_helper'

describe 'domain_from_fqdn' do
    it 'should reject less than one argument' do
        expect { subject.call([]) }.should raise_error(Puppet::ParseError, /Requires one argument/)
    end
    it 'should reject more than one argument' do
        expect { subject.call(['foo', 'bar']) }.should raise_error(Puppet::ParseError, /Requires one argument/)
    end

    describe 'when FQDN is a gTLD' do
        it 'should return false' do
            subject.call(['com']).should be_false
        end
    end
    describe 'when FQDN is a TLD' do
        it 'should return false' do
            subject.call(['example.com']).should be_false
        end
    end
    describe 'when FQDN is terminated with a dot' do
        it 'should not return a domain terminated with a dot' do
            subject.call(['foo.example.com.']).should_not =~ /\.$/
        end
    end

    {
        'foo.example.com' => 'example.com',
        'foo.bar.example.com' => 'bar.example.com',
        'foo.bar.baz.example.com' => 'bar.baz.example.com'
    }.each do |fqdn, domain|
        describe "when FQDN is #{fqdn}" do
            it "should return #{domain}" do
                subject.call([fqdn]).should == domain
            end
        end
    end
end
