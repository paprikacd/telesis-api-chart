# Telesis API Helm Chart

Standalone Helm chart for the Telesis API origin managed by Paprika.

## Defaults

- Image: `australia-southeast1-docker.pkg.dev/uptime-485903/uptime-prod-docker/api:ab2d5b3`
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
