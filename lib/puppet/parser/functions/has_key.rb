# Copyright (C) 2011 Puppet Labs Inc
# Copyright (C) 2011 Krzysztof Wilczynski
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

# Borrowed from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib

module Puppet::Parser::Functions

  newfunction(:has_key, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Determine if a hash has a certain key value.

    Example:

        $my_hash = {'key_one' => 'value_one'}
        if has_key($my_hash, 'key_two') {
          notice('we will not reach here')
        }
        if has_key($my_hash, 'key_one') {
          notice('this will be printed')
        }

    ENDHEREDOC

    unless args.length == 2
      raise Puppet::ParseError, ("has_key(): wrong number of arguments (#{args.length}; must be 2)")
    end
    unless args[0].is_a?(Hash)
      raise Puppet::ParseError, "has_key(): expects the first argument to be a hash, got #{args[0].inspect} which is of type #{args[0].class}"
    end
    args[0].has_key?(args[1])

  end

end
