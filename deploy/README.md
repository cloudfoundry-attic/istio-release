# deployment config

This directory contains config used to deploy Istio Release using CF Deployment Concourse Tasks v6

# Ops Files

## Most Used
- add-istio.yml the kitchen sink of (almost) everything it takes to deploy
  istio-control and istio-router to your CloudFoundry.
- add-external-istio-lb.yml is available to create a separate load balancer related
  just to istio traffic. It is separate so you can deploy istio components to
  bosh-lite without an lb.
- add-route-syncer.yml, used for standing-up the capi related route bulk syncer.
  This component periodically sends a dump of all route data to copilot

## Specialized
- local-istio-release.yml is used for building and deploying a development version
  of istio release.
- scale-diego-for-ci.yml is currently being used only during scale testing. More
  diego cells means more apps.
- scaling-test.yml scales capi/cells/istio-control/nozzle to make sure
  environment can handle over 10K applications (could be increased in future)
