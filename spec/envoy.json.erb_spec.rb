# rubocop:disable LineLength
# rubocop:disable BlockLength
require 'rspec'
require 'yaml'
require 'bosh/template/evaluation_context'
require 'json'

TEST_CERT = 'some

multiline

cert'.freeze

TEST_KEY = 'some

multi line key'.freeze

describe 'envoy.json.erb' do
  let(:deployment_manifest_fragment) do
    {
      'index' => 0,
      'job' => { 'name' => 'i_like_bosh' },
      'properties' => {
        'statsd' => { 'enabled' => false }
      }
    }
  end

  let(:erb_yaml) do
    File.read(File.join(File.dirname(__FILE__), '../jobs/envoy/templates/envoy.json.erb'))
  end

  subject(:parsed_yaml) do
    binding = Bosh::Template::EvaluationContext.new(deployment_manifest_fragment).get_binding
    eval(
      'class Link
        def instances()
          []
        end
      end
      def link(s)
        return Link.new()
      end', binding)
    JSON.parse(ERB.new(erb_yaml).result(binding))
  end

  context 'given a generally valid manifest' do
    context 'when statsd is not configured' do
      it 'should not configure the property stats_sinks' do
        expect(parsed_yaml['stats_sinks']).to eq(nil)
      end
    end
    context 'when statsd is configured' do
      let(:deployment_manifest_fragment) do
        {
          'index' => 0,
          'job' => { 'name' => 'i_like_bosh' },
          'properties' => {
            'statsd' => { 
              'enabled' => true,
              'address' => '127.0.0.1',
              'port' => 8125, 
              'protocol' => 'TCP',
            }
          }
        }
      end
      it 'should configure the statsd' do
        expect(parsed_yaml['stats_sinks']).not_to eq(nil)
        expect(parsed_yaml['stats_sinks']["config"]["address"]["socket_address"]["address"]).to eq("127.0.0.1")
        expect(parsed_yaml['stats_sinks']["config"]["address"]["socket_address"]["port_value"]).to eq(8125)
        expect(parsed_yaml['stats_sinks']["config"]["address"]["socket_address"]["protocol"]).to eq("TCP")
      end
    end
  end
end
