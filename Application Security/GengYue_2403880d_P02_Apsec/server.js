const express = require('express');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const User = require('./models/User');

// Import security middleware
const { securityHeaders, sanitizeInput, securityLogger } = require('./middleware/security');

dotenv.config();

if (!process.env.JWT_SECRET) {
  if (process.env.NODE_ENV === 'test') {
    // Use a default secret for testing
    process.env.JWT_SECRET = 'test-secret-key-for-testing-only';
    console.warn('Warning: Using default JWT_SECRET for testing environment');
  } else {
    console.error('Error: JWT_SECRET is not defined in your environment variables. Please check your .env file.');
    process.exit(1);
  }
}

process.env.JWT_EXPIRE = process.env.JWT_EXPIRE || '24h';

connectDB();

const auth = require('./routes/auth');
const admin = require('./routes/admin');
const manager = require('./routes/manager');
const analyst = require('./routes/analyst');
const client = require('./routes/client');

const app = express();

// Security middleware
app.use(securityHeaders);
app.use(securityLogger);
app.use(sanitizeInput);

// Middleware for parsing JSON
app.use(express.json({ limit: '10mb' })); // Limit payload size

// Serve static files from public directory
app.use(express.static('public'));

// Serve the main application page
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

// API info endpoint (for API documentation)
app.get('/api', (req, res) => {
  res.json({
    success: true,
    message: 'TechSecure Authentication and Authorization API',
    endpoints: {
      auth: '/api/auth',
      admin: '/api/admin',
      manager: '/api/manager',
      analyst: '/api/analyst',
      client: '/api/client'
    }
  });
});

app.use('/api/auth', auth);
app.use('/api/admin', admin);
app.use('/api/manager', manager);
app.use('/api/analyst', analyst);
app.use('/api/client', client);

const PORT = process.env.PORT || 5000;

const createDefaultUsers = async () => {
  try {
    const users = [
      {
        name: 'Admin User',
        email: 'admin@techsecure.com',
        password: 'admin123',
        role: 'admin'
      },
      {
        name: 'Manager User',
        email: 'manager@techsecure.com',
        password: 'manager123',
        role: 'manager'
      },
      {
        name: 'Analyst User',
        email: 'analyst@techsecure.com',
        password: 'analyst123',
        role: 'analyst'
      },
      {
        name: 'Client User',
        email: 'client@techsecure.com',
        password: 'client123',
        role: 'client'
      }
    ];

    for (const userData of users) {
      const userExists = await User.findOne({ email: userData.email });
      
      if (!userExists) {
        await User.create(userData);
        console.log(`Created user: ${userData.email} (${userData.role})`);
      } else {
        console.log(`User already exists: ${userData.email}`);
      }
    }
  } catch (error) {
    console.error('Error creating default users:', error.message);
  }
};

// Only start server if not in test environment
let server;
if (process.env.NODE_ENV !== 'test') {
  server = app.listen(PORT, async () => {
    console.log(`Server running on port ${PORT}`);
    await createDefaultUsers();
  });
  
  process.on('unhandledRejection', (err, promise) => {
    console.log(`Error: ${err.message}`);
    server.close(() => process.exit(1));
  });
}

module.exports = app; 