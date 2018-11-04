# deployment config

This directory contains config used to deploy Istio Release using CF Deployment Concourse Tasks v6

# Ops Files

## Most Used
- `add-istio.yml`: the kitchen sink of (almost) everything it takes to integrate istio into your CloudFoundry.
- `add-external-istio-lb.yml`: create a separate load balancer for ingress traffic to istio routers.  On bosh-lite, don't use this file.  On real infrastructures, use it.

## Specialized
- `local-istio-release.yml`: used for building and deploying a development version of istio release.
- `scale-diego-for-ci.yml`: currently being used only during scale testing. More diego cells means more apps.
- `scaling-test.yml`: scales capi/cells/istio-control/nozzle to make sure environment can handle over 10K applications (could be increased in future)
