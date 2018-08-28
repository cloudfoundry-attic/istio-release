#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"
export GOPATH=${PWD}
export PATH=$PATH:$GOPATH/bin

pushd src/code.cloudfoundry.org/copilot
  go install ./vendor/github.com/onsi/ginkgo/ginkgo
  ginkgo -r -p --randomizeAllSpecs --randomizeSuites --failOnPending --trace --race --progress
popd

pushd src/istio.io/istio
  export KUBECONFIG=$PWD/.circleci/config
  make localTestEnv
  make pilot-test
  make test/local/cloudfoundry/e2e_pilotv2
popd
