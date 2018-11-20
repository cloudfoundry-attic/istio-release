#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

docker run --rm -v "${PWD}":/workspace/istio-release cloudfoundry/cf-routing-pipeline /bin/bash /workspace/istio-release/test-release-linux.sh
