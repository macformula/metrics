#!/bin/bash

# Wait for Grafana to be ready
echo "Waiting for Grafana to be ready..."
until curl -s http://localhost:3000/api/health > /dev/null 2>&1; do
  sleep 2
done

echo "Grafana is ready. Creating public dashboard..."

# Get the dashboard UID
DASHBOARD_UID="racecar-telemetry"

# Create public dashboard using Grafana API
RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -u admin:admin \
  http://localhost:3000/api/dashboards/uid/${DASHBOARD_UID}/public-dashboards \
  -d '{
    "isEnabled": true,
    "annotationsEnabled": false,
    "timeSelectionEnabled": true,
    "share": "public"
  }')

# Extract the access token from response
ACCESS_TOKEN=$(echo $RESPONSE | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)

if [ -n "$ACCESS_TOKEN" ]; then
  echo "Public dashboard created successfully!"
  echo "Access token: $ACCESS_TOKEN"
  echo "Public URL: http://localhost:3000/public-dashboards/$ACCESS_TOKEN"
  
  # Save to a file for the frontend to read
  echo "VITE_GRAFANA_DASHBOARD_URL=http://localhost:3000/public-dashboards/$ACCESS_TOKEN" > /tmp/grafana-public-url.env
else
  echo "Failed to create public dashboard or it already exists"
  echo "Response: $RESPONSE"
fi
