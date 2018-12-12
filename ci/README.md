# Generic istio-dev pipeline

This directory contains a generic istio-dev pipeline for copilit and istio-release development.

# Workflow
1. Create a params file, generate certs and fill the following fields

    ```
    deployment_repo_uri: git@github.com:myorg/my-bbl-state-deployments-repo.git
    deployment_repo_private_key: "((credhub-refrerences-can-also-be-used))"
    gcp_service_account_key: path-or-key
    bbl_state_dir: environments/istio-dev
    bbl_gcp_region: my-gcp-region
    lb_domain: istio-dev.my-team.cf-app.com
    lb_cert: |
    ...
    lb_key: |
    ...
    committer_email: my-team+ci@pivotal.io
    istio_release_private_key: |
    ...
    ```

1. Set the pipeline

    ```fly -t ci sp -p istio-dev -c istio-dev-pipeline.yml -l params.yml```


1. BBL up a dev environment through the "maintenance" group.
1. Send the commits through the pipeline
