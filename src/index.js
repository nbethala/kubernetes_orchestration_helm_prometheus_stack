const express = require('express');
const client = require('prom-client');

const app = express();
const PORT = 3001;

// Prometheus setup
const register = new client.Registry();
client.collectDefaultMetrics({ register });

const requestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['route']
});
register.registerMetric(requestCounter);

const healthCheckCounter = new client.Counter({
  name: 'health_checks_total',
  help: 'Total number of health check requests'
});
register.registerMetric(healthCheckCounter);

// Middleware to count requests
app.use((req, res, next) => {
  requestCounter.inc({ route: req.path });
  next();
});

// Routes
app.get('/', (req, res) => {
  res.send(`<h1>🚀 DevOps App Ready For Deployment - Nancy B</h1>`);
});

// use this to test for prometheus to trigger an Alert to ALert Manager
//app.get('/fail', (_req, res) => {
//  res.status(500).send('Simulated error');
//});

app.get('/health', (req, res) => {
  healthCheckCounter.inc();
  res.json({
    status: 'healthy',
    time: new Date(),
    uptime: process.uptime()
  });
});

// ✅ Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
  console.log(`Metrics available at http://localhost:${PORT}/metrics`);
});
