#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"
export GOPATH=${PWD}
export PATH=$PATH:$GOPATH/bin

pushd src/code.cloudfoundry.org/copilot
  dep ensure
  ginkgo -r -p --randomizeAllSpecs --randomizeSuites --failOnPending --trace --race --progress
popd

pushd src/istio.io/istio/pilot
  dep ensure
  ginkgo -r -p --randomizeAllSpecs --randomizeSuites --failOnPending --trace --progress -skipPackage proxy/envoy,platform/kube,adapter/config/crd
popd
