# Copyright (C) 2011 Puppet Labs Inc
# Copyright (C) 2011 Krzysztof Wilczynski
# Copyright (C) 2012 Dan Carley
# 
# Puppet Labs can be contacted at: info@puppetlabs.com
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Adapted from puppetlabs-stdlib for rspec-puppet.
# https://github.com/puppetlabs/puppetlabs-stdlib

require 'spec_helper'

describe 'has_key' do
  describe 'when calling has_key from puppet' do
    it "should not compile when no arguments are passed" do
      expect { subject.call([]) }.should raise_error(Puppet::ParseError, /wrong number of arguments/)
    end
    it "should not compile when 1 argument is passed" do
      expect { subject.call([{'foo' => 'bar'}]) }.should raise_error(Puppet::ParseError, /wrong number of arguments/)
    end
    it "should require the first value to be a Hash" do
      expect { subject.call(['foo', 'bar']) }.should raise_error(Puppet::ParseError, /expects the first argument to be a hash/)
    end
  end
  describe 'when calling the function has_key from a scope instance' do
    it 'should detect existing keys' do
      subject.call([{'one' => 1}, 'one']).should be_true
    end
    it 'should detect existing keys' do
      subject.call([{'one' => 1}, 'two']).should be_false
    end
  end
end
