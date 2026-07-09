# Telesis API Helm Chart

Standalone Helm chart for the Telesis API origin managed by Paprika.

## Defaults

- API image: `australia-southeast1-docker.pkg.dev/uptime-485903/uptime-prod-docker/api:65e5ce5`
- Scheduler image: `australia-southeast1-docker.pkg.dev/uptime-485903/uptime-prod-docker/scheduler:ab2d5b3`
- Runner image: `australia-southeast1-docker.pkg.dev/uptime-485903/uptime-prod-docker/runner:ab2d5b3`
- Result processor image: `australia-southeast1-docker.pkg.dev/uptime-485903/uptime-prod-docker/resultprocessor:ab2d5b3`
- Rollup image: `australia-southeast1-docker.pkg.dev/uptime-485903/uptime-prod-docker/rollup:78fc26c`
- Pull secret: `telesis-gar`
- Runtime secret: `telesis-api-env`
- Firebase admin secret: `telesis-firebase-admin`
- Default service port: `9500`

## Validate

```bash
helm lint .
helm template telesis-api .
```

Paprika should point Applications at this repository with `source.type: git`, `source.revision: main`, and `source.path: "."`.
Push webhooks to Paprika are expected to trigger immediate sync, with the Application's 60-second poll interval as the fallback.

## Image Promotion

This chart owns image repositories and tags in `values.yaml`. Paprika Application manifests should not override image values; otherwise chart image bumps will be shadowed and will not change the rendered workload.
