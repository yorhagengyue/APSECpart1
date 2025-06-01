const express = require('express');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const User = require('./models/User');

dotenv.config();

if (!process.env.JWT_SECRET) {
  process.env.JWT_SECRET = '9f1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b';
  console.log('JWT_SECRET not found in environment, using hardcoded value');
}

process.env.JWT_EXPIRE = process.env.JWT_EXPIRE || '24h';

connectDB();

const auth = require('./routes/auth');
const admin = require('./routes/admin');
const manager = require('./routes/manager');
const analyst = require('./routes/analyst');
const client = require('./routes/client');
const apsec = require('./routes/apsec');

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Welcome to the TechSecure Authentication and Authorization API',
    endpoints: {
      auth: '/api/auth',
      admin: '/api/admin',
      manager: '/api/manager',
      analyst: '/api/analyst',
      client: '/api/client',
      apsec_register: {
        president: '/register-president',
        secretary: '/register-secretary',
        treasurer: '/register-treasurer',
        member: '/register-member'
      },
      apsec_auth: {
        login: '/login',
        logout: '/logout'
      },
      apsec_public: '/public',
      apsec_protected: {
        president: '/president-protected',
        secretary: '/secretary-protected',
        treasurer: '/treasurer-protected',
        member: '/member-protected'
      }
    }
  });
});

app.use('/api/auth', auth);
app.use('/api/admin', admin);
app.use('/api/manager', manager);
app.use('/api/analyst', analyst);
app.use('/api/client', client);
app.use('/', apsec);

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
      },
      {
        name: 'admin',
        username: 'admin',
        email: 'admin@example.com',
        password: 'password123',
        role: 'president'
      },
      {
        name: 'secretary',
        username: 'secretary',
        email: 'secretary@example.com',
        password: 'password123',
        role: 'secretary'
      },
      {
        name: 'treasurer',
        username: 'treasurer',
        email: 'treasurer@example.com',
        password: 'password123',
        role: 'treasurer'
      },
      {
        name: 'member',
        username: 'member',
        email: 'member@example.com',
        password: 'password123',
        role: 'member'
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

const server = app.listen(PORT, async () => {
  console.log(`Server running on port ${PORT}`);
  await createDefaultUsers();
});

process.on('unhandledRejection', (err, promise) => {
  console.log(`Error: ${err.message}`);
  server.close(() => process.exit(1));
}); 