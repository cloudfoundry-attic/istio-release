# testing failover

Use the example app in `src/examples/mysql-web-client` to test the connection to a MySQL DB.

## on client side deployment
1. configure `ServiceEntry` for the local service instance with a VIP that redirects through the local Envoy proxy

   (service broker should manage, same lifetime as the service instance)

    ```yaml
    apiVersion: networking.istio.io/v1alpha3
    kind: ServiceEntry
    metadata:
      name: service-instance-guid.service.mesh
    spec:
      hosts:
      - service-instance-guid.service.mesh
      addresses:
      - 127.255.0.7  # Virtual IP, should be in range 127.128.0.0/9
      ports:
      - number: 3306
        name: mysql
        protocol: TCP
      location: MESH_INTERNAL
      resolution: STATIC
      endpoints:
      - address: 2.2.2.2  # actual IP address of MySQL Server
    ```
   
2. set a `DestinationRule` specifying TLS settings

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: service-instance-guid.service.mesh
spec:
  host: mydbserver.prod.svc.cluster.local
  trafficPolicy:
    tls:
      mode: MUTUAL
      clientCertificate: /etc/certs/myclientcert.pem
      privateKey: /etc/certs/client_private_key.pem
      caCertificates: /etc/certs/rootcacerts.pem
```
   
2. configure `VirtualService`, that matches the VIP used by clients to connect

   - use a `DestinationRule` to pick the client certs?
   - redirect to the `ServiceEntry`

## on backup deployment
1. configure `SNI-DNAT` passthrough gateway

    ```yaml
    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
      name: sni-passthrough
      namespace: cf-istio-system
    spec:
    #  selector:
    #    router: istio-router
      servers:
      - port:
          number: 1443
          name: sni-passthrough
          protocol: TLS  # this causes SNI passthrough without decrypting
        hosts:
        - "*.service.mesh" # or the server name in the service instance server cert?
        tls:
          mode: PASSTHROUGH  # also explore AUTO_PASSTHROUGH?
    ``` 

2. configure `VirtualService`, that matches the SNI name

   (optional if we use `AUTO_PASSTHROUGH`?)

3. configure `ServiceEntry` for the backup Service Instance

   (service broker should manage, same lifetime as the service instance)
