#
# Copyright 2015, Noah Kantrowitz
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

require 'net/http'

require 'serverspec'
set :backend, :exec


describe 'rails', if: File.exists?('/opt/test_rails') do
  describe port(9001) do
    it { is_expected.to be_listening }
  end

  let(:http) { Net::HTTP.new('localhost', 9001) }

  describe '/' do
    subject { http.get('/') }
    its(:code) { is_expected.to eq '200' }
    its(:body) { is_expected.to include '<h1>Hello, Rails!</h1>' }
  end

  describe '/articles' do
    subject { http.get('/articles') }
    its(:code) { is_expected.to eq '200' }
    its(:body) { is_expected.to include '<h1>Listing articles</h1>' }
  end
end
