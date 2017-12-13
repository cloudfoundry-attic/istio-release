# Istio + Cloudfoundry

This repo is a [BOSH release](https://github.com/cloudfoundry/bosh) that
packages [Istio](https://istio.io/) and [Envoy](https://github.com/envoyproxy/envoy) for Cloud Foundry. This is not feature complete and
under heavy development, proceed with caution.

# Create Release & deploy

## Requirements
Istio-release requires [bosh-cli](https://bosh.io/docs/cli-v2.html#install) >= `2.0.45`.

```
git clone https://github.com/cloudfoundry-incubator/istio-release

cd istio-release/
./scripts/update

bosh create-release && bosh upload-release

bosh deploy cf.yml -o add-istio-release.yml
```
Note: add-istio-release operation file is located in [routing-ci](https://github.com/cloudfoundry/routing-ci/blob/master/operations/add-istio-release.yml)


# Running Tests

```
./scripts/update # to sync all the submodules
./test
```
