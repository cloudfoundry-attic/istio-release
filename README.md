# Deprecated
Development has been suspended for Istio integration with cf-deployment on BOSH.

Please look at [cf-for-k8s](https://github.com/cloudfoundry/cf-for-k8s) for an Istio integration with Cloud Foundry on Kubernetes.



## Istio + Cloud Foundry (on BOSH)

This repo is a [BOSH release](https://github.com/cloudfoundry/bosh) that
packages [Istio](https://istio.io/) and [Envoy](https://github.com/envoyproxy/envoy) for support of Service Mesh use cases in Cloud Foundry.

### Deployment
Follow these [steps](https://docs.cloudfoundry.org/running/deploying-service-mesh.html) to deploy the istio routing tier with your Cloud Foundry

### Contributing to istio-release
Please follow our [Code of Conduct](https://www.cloudfoundry.org/code-of-conduct/).

#### Running Tests
Before submitting a PR, please run our tests and update any tests relevant to
your changes.

#### Run release tests
Test your changes to istio-release. This script tests changes in copilot and in
the BOSH release.

```
./scripts/update # to sync all the submodules
./scripts/test
```

#### Run upstream tests
Test your integration with upstream Istio. This runs the Pilot-related tests within
istio.io/istio.

```
./scripts/update # to sync all the submodules
./test-upstream-linux.sh or ./test-upstream-mac.sh
```
