// Setup and Configuration
const express = require('express');
const app = express();
const PORT = 3001;

// Basic Metrics Tracking : HTTP request and Health check
let requestCount = 0;
let healthCheckCount = 0;
const startTime = Date.now();

// Middleware for Request Counting : increments count for every incoming request
app.use((req, res, next) => {
  requestCount++;
  next();
});

// Home Page Route : HTML page with live timestamp
app.get('/', (req, res) => {
  res.send(`
    <h1>🚀 Devops App Ready For Deployment - Nancy B</h1>
    <h1>Do the difficult things while they are easy and do the great things while they are small.</h1>
    <h1>A journey of a thousand miles must begin with a single step -Lao Tzu</h1>
    <p>This app was deployed automatically!</p>
    <p>Current time: ${new Date().toLocaleString()}</p>
    <p>Total requests: ${requestCount}</p>
  `);
});

// Health Check Endpoint: app health status(JSON PAYLOAD)
app.get('/health', (req, res) => {
  healthCheckCount++;
  res.json({ 
    status: 'healthy', 
    time: new Date(),
    uptime: process.uptime(),
    requests: requestCount
  });
});

// Start the Express server
app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
  console.log(`Health status available at http://localhost:${PORT}/health`);
});