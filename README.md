# Istio + Cloudfoundry

This repo is a [BOSH release](https://github.com/cloudfoundry/bosh) that
packages [Istio](https://istio.io/) and [Envoy](https://github.com/envoyproxy/envoy) for Cloud Foundry.

This release is under heavy development and not yet ready for use.

## Setup a `cf-deployment` environment with `istio-release`
[cf-deployment-concourse-tasks](https://github.com/cloudfoundry/cf-deployment-concourse-tasks) v6
- GCP only for right now
- configure the `bbl-up` task with our custom [bbl-config](deploy/bbl-config) to deploy dedicated load balancers for the new Istio ingress routers
- configure `bosh-deploy` task with our custom [operations file](deploy/cf-deployment-operations)

## Deploy with bosh cli

This assumes you have already paved your infrastructure, e.g. BBLv6 with [our patches](deploy/bbl-config).

```
git clone https://github.com/cloudfoundry-incubator/istio-release

cd istio-release/
./scripts/update

bosh create-release && bosh upload-release

bosh deploy cf.yml -o deploy/cf-deployment-operations/add-istio.yml
```


## Running Tests

```
./scripts/update # to sync all the submodules
./test
```
