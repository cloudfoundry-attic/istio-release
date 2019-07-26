## Galley-fs

### Overview

Galley-fs is a job that deploys galley. The galley reads config from all files in `/var/vcap/data/istio-config`. The pilot discovery system, which configures the edge envoy, gets configuration from this galley *and* from copilot.

### Deploy

If you already have istio deployed, then use the [`add-galley-fs.yml` opsfile ](../deploy/cf-deployment-operations/add-galley-fs.yml).
If you don't have istio deployed already, then you can use the [`add-istio.yml` opsfile](../deploy/cf-deployment-operations/add-istio.yml) and it will add galley-fs.

You will also need to deploy the istio-release from the [`dealers_choice`](https://github.com/cloudfoundry/istio-release/tree/dealers_choice) branch of this repo.

### Use by hand

1. Make istio config
2. Put the file in the directory: `/var/vcap/data/istio-config`

### Scripts

#### Make istio config for a route 
```
./istio-release/scripts/make-istio-config-for-route <app-name> <full-route>
```

#### Upload the config files one by one

```
./set-galley-config update <istio-config-filepath>
```

#### Burn it down :fire:
This deletes all configuration for galley
```
./set-galley-config burn-it-down
```
