// Test environment setup
const path = require('path');

// Set default test environment variables if not already set
process.env.NODE_ENV = 'test';

// Set default JWT_SECRET for testing if not provided
if (!process.env.JWT_SECRET) {
    process.env.JWT_SECRET = 'test-secret-key-for-testing-only';
    console.log('Using default JWT_SECRET for testing');
}

// Set default MongoDB URI for testing if not provided
if (!process.env.MONGODB_URI) {
    process.env.MONGODB_URI = 'mongodb://localhost:27017/techsecure-test';
    console.log('Using default MONGODB_URI for testing');
}

// Set default port for testing
if (!process.env.PORT) {
    process.env.PORT = '5001'; // Different port for testing
}

// Disable console.log during tests unless explicitly needed
if (process.env.SILENT_TESTS === 'true') {
    console.log = jest.fn();
}

module.exports = {}; 