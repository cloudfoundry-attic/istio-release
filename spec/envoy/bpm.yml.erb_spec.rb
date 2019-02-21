# rubocop:disable BlockLength
# rubocop:disable LineLength
require 'rspec'
require 'yaml'
require 'bosh/template/test'

describe 'bpm.yml.erb' do
  let(:deployment_manifest_fragment) do
    {
    }
  end

  let(:release_path) { File.join(File.dirname(__FILE__), '../..') }
  let(:release) { Bosh::Template::Test::ReleaseDir.new(release_path) }
  let(:job) { release.job('envoy') }

  subject(:parsed_yaml) do
    template = job.template('config/bpm.yml')
    YAML.safe_load(template.render(deployment_manifest_fragment))
  end

  context 'given a generally valid manifest' do
    it 'renders' do
      expect(parsed_yaml).to eq(
        'processes' => [
          {
            'args' => [
              '-c /var/vcap/jobs/envoy/config/envoy.json',
              '--max-obj-name-len 200',
              '--v2-config-only'
            ],
            'capabilities' => ['NET_BIND_SERVICE'],
            'executable' => '/var/vcap/packages/envoy/bin/envoy',
            'hooks' => { 'pre_start' => '/var/vcap/jobs/envoy/bin/bpm-pre-start' },
            'limits' => { 'open_files' => 1024 },
            'name' => 'envoy'
          }
        ]
      )
    end

    context 'when overriding open files' do
      before do
        deployment_manifest_fragment['open_files'] = 42
      end

      it 'renders accordingly' do
        expect(parsed_yaml['processes'][0]['limits']['open_files']).to eq(42)
      end
    end
  end
end
