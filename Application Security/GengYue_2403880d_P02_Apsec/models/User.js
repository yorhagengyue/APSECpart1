const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const UserSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Please add a name']
  },
  email: {
    type: String,
    required: [true, 'Please add an email'],
    unique: true,
    match: [
      /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/,
      'Please add a valid email'
    ]
  },
  role: {
    type: String,
    enum: ['admin', 'manager', 'analyst', 'client'],
    default: 'client'
  },
  address: {
    type: String,
    required: false
  },
  password: {
    type: String,
    required: [true, 'Please add a password'],
    minlength: 6,
    select: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  isEmailVerified: {
    type: Boolean,
    default: false
  },
  emailVerificationToken: {
    type: String,
    default: null
  },
  emailVerificationExpires: {
    type: Date,
    default: null
  },
  verifiedAt: {
    type: Date,
    default: null
  }
});

// Encrypt password
UserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Generate JWT
UserSchema.methods.getSignedJwtToken = function() {
  if (!process.env.JWT_SECRET) {
    if (process.env.NODE_ENV === 'test') {
      process.env.JWT_SECRET = 'test-secret-key-for-testing-only';
    } else {
      throw new Error('JWT_SECRET is not defined in environment variables');
    }
  }
  
  return jwt.sign({ 
    id: this._id,
    role: this.role,
    email: this.email
  }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '24h'
  });
};

// Alias for getSignedJwtToken (for backward compatibility)
UserSchema.methods.generateAuthToken = function() {
  return this.getSignedJwtToken();
};

// Validate password
UserSchema.methods.matchPassword = async function(enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = mongoose.model('User', UserSchema); 