#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"
export GOPATH=${PWD}
export PATH=$PATH:$GOPATH/bin

# Setup iptables REDIRECT rule for CloudFoundry Pilot test
sudo apt update
sudo apt install -y iptables
sudo iptables -t nat -A OUTPUT -d 127.1.1.1/32 -p tcp -j REDIRECT --to-port 15001

pushd src/code.cloudfoundry.org/copilot
  dep ensure
  go install ./vendor/github.com/onsi/ginkgo/ginkgo
  ginkgo -r -p --randomizeAllSpecs --randomizeSuites --failOnPending --trace --race --progress
popd

pushd src/istio.io/istio
  export KUBECONFIG=$PWD/.circleci/config
  dep ensure
  make localTestEnv
  make pilot-test
  make test/local/cloudfoundry/e2e_pilotv2
popd

# Clean up iptables rule
sudo iptables -t nat -D OUTPUT -d 127.1.1.1/32 -p tcp -j REDIRECT --to-port 15001
