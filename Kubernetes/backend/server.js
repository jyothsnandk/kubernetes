const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Sample data
let messages = [];

// Routes
app.get('/api/data', (req, res) => {
  res.json({
    message: 'Hello from Express Backend!',
    timestamp: new Date().toISOString(),
    service: 'backend',
    messages: messages,
    hostname: process.env.HOSTNAME || 'unknown'
  });
});

app.post('/api/message', (req, res) => {
  const { message } = req.body;
  
  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }
  
  const messageObj = {
    id: messages.length + 1,
    message: message,
    timestamp: new Date().toISOString()
  };
  
  messages.push(messageObj);
  
  res.json({
    success: true,
    data: messageObj,
    totalMessages: messages.length
  });
});

app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    service: 'backend',
    timestamp: new Date().toISOString()
  });
});

app.get('/', (req, res) => {
  res.json({
    message: 'Express Backend API',
    endpoints: [
      'GET /api/data',
      'POST /api/message',
      'GET /health'
    ]
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Express backend server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
