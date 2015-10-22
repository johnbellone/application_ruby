#
# Copyright 2015, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider'
require 'chef/resource'

require 'poise_application_ruby/app_mixin'

module PoiseApplicationRuby
  module Resources
    # @see Dotenv::Resource
    module Dotenv
      # Resource for `application_dotenv`.
      # @since 4.1.0
      # @see Provider
      # @provides application_dotenv
      class Resource < Chef::Resource
        include PoiseApplicationRuby::AppMixin
        provides(:application_dotenv)
        actions(:deploy)

        # @!attribute dotenv
        #   Option collector attribute for Rack dotenv configuration.
        # @example Setting via block
        #   dotenv do
        #     zookeeper_dsn '127.0.0.1,127.0.1.1,127.0.2.1/corporate.com'
        #   end
        # @example Setting via Hash
        #   environment Hash.new(zookeeper_dsn: '127.0.0.1,127.0.1.1,127.0.2.1/corporate.com')
        attribute(:dotenv, option_collector: true, default: lazy { environment })
      end

      # Provider for `application_dotenv`.
      # @since 4.1.0
      # @see Resource
      # @provides application_dotenv
      class Provider
        # `deploy` action for the `application_dotenv`. Ensures that
        # all configuration files are created.
        def action_deploy # rubocop:disable Metrics/AbcSize
          notifying_block do
            rc_file ::File.join(new_resource.path, '.env') do
              type 'bash'
              user new_resource.parent.owner
              group new_resource.parent.group
              mode '640'
              options(new_resource.dotenv)
            end
          end
        end
      end
    end
  end
end
