# Istio + Cloud Foundry

This repo is a [BOSH release](https://github.com/cloudfoundry/bosh) that
packages [Istio](https://istio.io/) and [Envoy](https://github.com/envoyproxy/envoy) for support of Service Mesh use cases in Cloud Foundry.

> **Note:** This release is under heavy development and not yet ready for use.

## Getting Help

For help or questions with this release or any of its submodules, you can reach the maintainers on Slack at [cloudfoundry.slack.com](https://cloudfoundry.slack.com) in the `#networking` channel.

## Deployment

### Setup a `cf-deployment` environment with `istio-release`
[cf-deployment-concourse-tasks](https://github.com/cloudfoundry/cf-deployment-concourse-tasks) v6
- GCP only for right now
- configure the `bbl-up` task with our custom [bbl-config](deploy/bbl-config) to deploy dedicated load balancers for the new Istio ingress routers
- configure `bosh-deploy` task with our custom [operations file](deploy/cf-deployment-operations)

### Deploy with bosh cli

This assumes you have already paved your infrastructure, e.g. BBLv6 with [our patches](deploy/bbl-config).

```
git clone https://github.com/cloudfoundry-incubator/istio-release

cd istio-release/
./scripts/update

bosh create-release && bosh upload-release

bosh deploy cf.yml -o deploy/cf-deployment-operations/add-istio.yml
```


## Running Tests

### Run release tests
Test your changes to istio-release. This script tests changes in copilot and in
the BOSH release.

```
./scripts/update # to sync all the submodules
./test-release-linux.sh or ./test-release-mac.sh
```

### Run upstream tests
Test your integration with upstream Istio. This runs the Pilot-related tests within
istio.io/istio.

```
./scripts/update # to sync all the submodules
./test-upstream-linux.sh or ./test-upstream-mac.sh
```

## Contributing to istio-release
Please follow our [Code of Conduct](https://www.cloudfoundry.org/code-of-conduct/).
