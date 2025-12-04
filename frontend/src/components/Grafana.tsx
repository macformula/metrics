// In your React component
function GrafanaChart() {
  const dashboardUrl =
    import.meta.env.VITE_GRAFANA_DASHBOARD_URL ||
    "/grafana/public-dashboards/986fe1bddd004c149460b9d6cdcb5e54";

  return (
    <iframe
      src={dashboardUrl}
      width="800"
      height="500"
      frameBorder={0}
      title="Grafana Dashboard"
    />
  );
}
export default GrafanaChart;
