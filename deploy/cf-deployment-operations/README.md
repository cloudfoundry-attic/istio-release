Prerequisites: `cf-deployment` with the `enable-routing-integrity` ops-file.

To deploy on full bosh, apply these ops-files:
- `add-istio.yml`
- `enable-sidecar-egress-proxying.yml`
- `add-external-istio-lb.yml`

To deploy on bosh-lite, apply these ops-files:
- `add-istio.yml`
- `add-route-syncer.yml`
