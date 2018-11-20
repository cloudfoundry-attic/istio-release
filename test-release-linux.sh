#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"
export GOPATH=${PWD}
export PATH=$PATH:$GOPATH/bin

bundle
bundle exec rspec

pushd src/code.cloudfoundry.org/copilot
  dep ensure
  go install ./vendor/github.com/onsi/ginkgo/ginkgo
  ginkgo -r -p --randomizeAllSpecs --randomizeSuites --failOnPending --trace --race --progress
popd
