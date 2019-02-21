# rubocop:disable LineLength
# rubocop:disable BlockLength
require 'rspec'
require 'yaml'
require 'bosh/template/test'
require 'json'

TEST_CERT = 'some

multiline

cert'.freeze

TEST_KEY = 'some

multi line key'.freeze

describe 'config.json.erb' do
  let(:deployment_manifest_fragment) do
    {
      'listen_port_for_mcp' => 9009,
      'pilot_client_ca_cert' => 'pilot-ca',
      'listen_port_for_cloud_controller' => 9001,
      'listen_port_for_vip_resolver' => 9002,
      'cloud_controller_ca_cert' => 'cc-ca',
      'server_cert' => 'server-cert',
      'server_key' => 'server-key',
      'experimental_vip_cidr' => '127.128.0.0/9',
      'log_level' => 'fatal',
      'bbs' => {
        'sync_interval' => '30s',
        'server_ca_cert' => 'bbs-ca',
        'client_cert' => 'bbs-client',
        'client_key' => 'bbs-key',
        'address' => 'https://bbs.service.cf.internal:8889',
        'client_session_cache_size' => 0,
        'max_idle_conns_per_host' => 0
      },
      'frontend_tls_keypairs' => [
        {
          'cert_chain' => 'test-chain',
          'private_key' => 'test-key'
        },
        {
          'cert_chain' => 'test-chain2',
          'private_key' => 'test-key2'
        }
      ]
    }
  end

  let(:release_path) { File.join(File.dirname(__FILE__), '..') }
  let(:release) { Bosh::Template::Test::ReleaseDir.new(release_path) }
  let(:job) { release.job('copilot') }

  subject(:parsed_yaml) do
    template = job.template('config/config.json')
    JSON.parse(template.render(deployment_manifest_fragment))
  end

  context 'given a generally valid manifest' do
    context 'frontend_tls_keypairs' do
      context 'when correct frontend_tls_keypairs is provided' do
        it 'should configure the property' do
          expect(parsed_yaml['TLSPems'].length).to eq(2)
          expect(parsed_yaml['TLSPems'][0]).to eq('CertChain' => 'test-chain',
                                                  'PrivateKey' => 'test-key')
          expect(parsed_yaml['TLSPems'][1]).to eq('CertChain' => 'test-chain2',
                                                  'PrivateKey' => 'test-key2')
        end
      end

      context 'when an incorrect frontend_tls_keypairs value is provided with missing cert' do
        before do
          deployment_manifest_fragment['frontend_tls_keypairs'] = [{ 'private_key' => 'test-key' }]
        end

        it 'should error' do
          expect { raise parsed_yaml }.to raise_error(RuntimeError, 'must provide cert_chain and private_key with frontend_tls_keypairs')
        end
      end

      context 'when an incorrect frontend_tls_keypairs value is provided with missing key' do
        before do
          deployment_manifest_fragment['frontend_tls_keypairs'] = [{ 'cert_chain' => 'test-chain' }]
        end

        it 'should error' do
          expect { raise parsed_yaml }.to raise_error(RuntimeError, 'must provide cert_chain and private_key with frontend_tls_keypairs')
        end
      end

      context 'when an incorrect frontend_tls_keypairs value is provided as wrong format' do
        before do
          deployment_manifest_fragment['frontend_tls_keypairs'] = ['cert']
        end
        it 'should error' do
          expect { raise parsed_yaml }.to raise_error(RuntimeError, 'must provide cert_chain and private_key with frontend_tls_keypairs')
        end
      end

      context 'when an incorrect frontend_tls_keypairs value is not provided as an array' do
        before do
          deployment_manifest_fragment['frontend_tls_keypairs'] = 'cert'
        end
        it 'should error' do
          expect { raise parsed_yaml }.to raise_error(RuntimeError, 'frontend_tls_keypairs should be an array')
        end
      end
    end
  end
end
