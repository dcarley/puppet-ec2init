require 'spec_helper'

describe 'ec2init::start' do
    %w{user sudo hostname ssh puppet ddns}.each do |klass|
        it { should include_class("ec2init::#{klass}") }
    end
end
