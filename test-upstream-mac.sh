#!/bin/bash

set -euo pipefail

ROOT="$(dirname "$0")"

IMAGE="$(bosh int $ROOT/ci/istio-upstream-tests.yml --path /image_resource/source/repository)"
TAG="$(bosh int $ROOT/ci/istio-upstream-tests.yml --path /image_resource/source/tag)"

cd $ROOT

docker run --privileged=true --rm -v "${PWD}":/workspace/istio-release "$IMAGE:$TAG" /bin/bash /workspace/istio-release/test-upstream-linux.sh
