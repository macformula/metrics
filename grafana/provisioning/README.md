# Grafana Provisioning

This directory contains Grafana provisioning configuration for automatic setup on container startup.

## What's Provisioned

### Data Sources (`datasources/influxdb.yml`)

- **InfluxDB** connection automatically configured
- Points to `http://influxdb:8086` (the Docker service)
- Uses the InfluxDB token from your environment
- Organization: `racecar`
- Default bucket: `telemetry`

### Dashboards (`dashboards/`)

- **dashboard.yml**: Configuration file that tells Grafana where to find dashboard JSON files
- **racecar-telemetry.json**: Sample dashboard with a basic time series panel

## How It Works

When Grafana starts, it automatically:

1. Connects to your InfluxDB instance
2. Loads any dashboard JSON files from the `dashboards/` directory
3. Makes them available immediately without manual configuration

## Customizing Dashboards

1. Create your dashboard in Grafana UI
2. Export it as JSON (Share → Export → Save to file)
3. Place the JSON file in `grafana/provisioning/dashboards/`
4. Restart Grafana container

Or edit the `racecar-telemetry.json` file directly to customize the sample dashboard.

## Configuration Options

- **datasources/influxdb.yml**:
  - `editable: true` - allows editing in Grafana UI
  - `isDefault: true` - makes this the default data source
- **dashboards/dashboard.yml**:
  - `allowUiUpdates: true` - allows modifying dashboards in UI
  - `disableDeletion: false` - allows deleting provisioned dashboards

## Restart to Apply

After making changes, restart Grafana:

```bash
docker-compose restart grafana
```
