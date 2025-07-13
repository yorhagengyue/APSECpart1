const express = require('express');
const https = require('https');
const http = require('http');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const User = require('./models/User');

// Import security middleware
const { securityHeaders, sanitizeInput, securityLogger } = require('./middleware/security');

dotenv.config();

if (!process.env.JWT_SECRET) {
  if (process.env.NODE_ENV === 'test') {
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

// Apply security headers to all routes
app.use(securityHeaders);

// Body parser
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Apply input sanitization to all routes
app.use(sanitizeInput);

// Apply security logging
app.use(securityLogger);

// Serve static files from public directory
app.use(express.static('public'));

// Mount routers
app.use('/api/auth', auth);
app.use('/api/admin', admin);
app.use('/api/manager', manager);
app.use('/api/analyst', analyst);
app.use('/api/client', client);

// Root route
app.get('/', (req, res) => {
  res.redirect('/index.html');
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

const PORT = process.env.PORT || 5000;
const HTTPS_PORT = process.env.HTTPS_PORT || 5443;

// HTTPS Configuration
const httpsOptions = {
  key: null,
  cert: null
};

// Try to load SSL certificates
try {
  httpsOptions.key = fs.readFileSync(path.join(__dirname, 'certificates', 'server.key'));
  httpsOptions.cert = fs.readFileSync(path.join(__dirname, 'certificates', 'server.crt'));
  console.log('✅ SSL certificates loaded successfully');
} catch (error) {
  console.error('❌ SSL certificates not found. Please run: node scripts/generate-ssl-cert-simple.js');
  process.exit(1);
}

// Create default users function
const createDefaultUsers = async () => {
  try {
    const defaultUsers = [
      { name: 'Admin User', email: 'admin@techsecure.com', password: 'Admin@123', role: 'admin' },
      { name: 'Manager User', email: 'manager@techsecure.com', password: 'Manager@123', role: 'manager' },
      { name: 'Analyst User', email: 'analyst@techsecure.com', password: 'Analyst@123', role: 'analyst' },
      { name: 'Client User', email: 'client@techsecure.com', password: 'Client@123', role: 'client' }
    ];

    for (const userData of defaultUsers) {
      const existingUser = await User.findOne({ email: userData.email });
      if (!existingUser) {
        await User.create(userData);
        console.log(`Created default ${userData.role} user: ${userData.email}`);
      }
    }
  } catch (error) {
    console.error('Error creating default users:', error.message);
  }
};

// Enhanced HTTPS Security Middleware
app.use((req, res, next) => {
  // Strict Transport Security
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  
  // Additional security headers for HTTPS
  res.setHeader('Content-Security-Policy', "default-src 'self' https:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.google.com https://www.gstatic.com; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; font-src 'self' https://cdnjs.cloudflare.com; img-src 'self' data: https:; frame-src https://www.google.com");
  
  next();
});

// Redirect HTTP to HTTPS
const httpApp = express();
httpApp.use((req, res) => {
  const httpsUrl = `https://${req.hostname}:${HTTPS_PORT}${req.url}`;
  res.redirect(301, httpsUrl);
});

// Only start servers if not in test environment
if (process.env.NODE_ENV !== 'test') {
  // Start HTTPS server
  const httpsServer = https.createServer(httpsOptions, app);
  httpsServer.listen(HTTPS_PORT, async () => {
    console.log(`🔒 HTTPS Server running on https://localhost:${HTTPS_PORT}`);
    await createDefaultUsers();
  });

  // Start HTTP server (redirects to HTTPS)
  const httpServer = http.createServer(httpApp);
  httpServer.listen(PORT, () => {
    console.log(`🔀 HTTP Server running on http://localhost:${PORT} (redirects to HTTPS)`);
  });

  // Handle unhandled promise rejections
  process.on('unhandledRejection', (err, promise) => {
    console.log(`Error: ${err.message}`);
    httpsServer.close(() => process.exit(1));
    httpServer.close(() => process.exit(1));
  });
}

module.exports = app; 