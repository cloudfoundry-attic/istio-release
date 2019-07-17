Prerequisites: `cf-deployment` with the `enable-routing-integrity` ops-file.

To deploy on full bosh, apply these ops-files:
- `add-istio.yml`
- `enable-sidecar-egress-proxying.yml`
- `add-external-istio-lb.yml`

To deploy on bosh-lite, apply these ops-files:
- `add-istio.yml`


| Name | Purpose | Notes |
|:---  |:---     |:---   |
| [`add-external-istio.lb.yml`](add-external-istio.lb.yml)| Adds the `cf-istio-router-network-properties` vm extension to the istio router. This extension is defined in `ci/planpatches/cloud-config/istio.yml`. This is needed to setup the load balancer for the istio rotuer.| |
| [`add-istio.yml`](add-istio.yml) | Optionally enables istio service mesh for external routes | |
| [`disable-ingress-sidecar-proxying.yml`](disable-ingress-sidecar-proxying.yml) | Disables redirecting all traffic entering the app container to the sidecar envoy.  | Currently the redirect feature breaks tcp routes (and maybe other things) so this opsfile is needed if you want those things to continue working. | 
| [`enable-sidecar-proxying.yml`](enable-sidecar-proxying.yml) | Optionally enables istio service mesh for internal routes on a per domain basis. | This opsfile results in all traffic for defined internal mesh routes being proxied through the sidecar envoy for the source app before being send to the destination app. It also results in _all_ traffic entering the app container to be redirected to the destination sidecar envoy (this is for the half completed mtls feature). This ingress redirect breaks tcp routing (and maybe other things). If you want tcp routing to continue working, you must use the `disable-ingress-sidecar-proxying.yml` opsfile in addition to this one. |
| [`enable-tls-termination.yml`](enable-tls-termination.yml) | ??? | ??? |
| [`local-istio-release.yml`](local-istio-release.yml) | Use istio located at file:///Users/pivotal/workspace/istio-release | |
| [`remove-pilot-from-diego-cell.yml`](remove-pilot-from-diego-cell.yml) | Removes pilot from Diego Cell| Why? Don't know?|
| [`scale-diego-for-ci.yml`](scale-diego-for-ci.yml) | Scales to 4 diego cell instances| |
| [`scaling-test.yml`](scaling-test.yml) | Scales to a large deployment for scaling tests| 100 Diego Cells, 10 API, 5 cc workers, 14 dopplers, 12 log-api, 12 nozzle  |
| [`use-latest-capi-release.yml`](use-latest-capi-release.yml) | Use latest capi release | |
| [`use-latest-cf-networking-release.yml`](use-latest-cf-networking-release.yml) | Use latest cf networking release | |
| [`use-latest-mysql-release.yml`](use-latest-mysql-release.yml) | Use latest mysql release | |
| [`use-latest-routing-release.yml`](use-latest-routing-release.yml) | Use latest routing release | |
| [`use-latest-silk-release.yml`](use-latest-silk-release.yml) | Use latest silk release | |

