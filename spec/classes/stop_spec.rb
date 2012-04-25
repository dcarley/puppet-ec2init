require 'spec_helper'

describe 'ec2init::stop' do
    %w{ddns::stop}.each do |klass|
        it { should include_class("ec2init::#{klass}") }
    end
end
