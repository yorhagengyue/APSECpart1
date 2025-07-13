const User = require('../models/User');
const crypto = require('crypto');
const { handleFailedLogin, handleSuccessfulLogin } = require('../middleware/rateLimiter');
const { sendEmail, emailTemplates, verifyEmailConfig } = require('../config/email');

// Simple password policy validation for backend
function validatePasswordPolicy(password, userInfo = {}) {
    const errors = [];
    
    // Check minimum length
    if (password.length < 8) {
        errors.push('Password must be at least 8 characters long');
    }
    
    // Check for uppercase letters
    if (!/[A-Z]/.test(password)) {
        errors.push('Password must contain at least one uppercase letter');
    }
    
    // Check for lowercase letters
    if (!/[a-z]/.test(password)) {
        errors.push('Password must contain at least one lowercase letter');
    }
    
    // Check for numbers
    if (!/\d/.test(password)) {
        errors.push('Password must contain at least one number');
    }
    
    // Check for special characters
    if (!/[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(password)) {
        errors.push('Password must contain at least one special character');
    }
    
    // Check against common passwords
    const commonPasswords = ['password', '123456', '123456789', 'qwerty', 'abc123', 'password123', 'admin'];
    if (commonPasswords.includes(password.toLowerCase())) {
        errors.push('This password is too common. Please choose a more unique password');
    }
    
    // Check against user information
    if (userInfo.name && password.toLowerCase().includes(userInfo.name.toLowerCase())) {
        errors.push('Password should not contain your name');
    }
    if (userInfo.email && password.toLowerCase().includes(userInfo.email.split('@')[0].toLowerCase())) {
        errors.push('Password should not contain your email');
    }
    
    return {
        isValid: errors.length === 0,
        errors: errors
    };
}

// @desc    Register user
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  try {
    const { name, email, password, role, address } = req.body;

    // Validate password policy
    const passwordValidation = validatePasswordPolicy(password, { name, email });
    if (!passwordValidation.isValid) {
      return res.status(400).json({
        success: false,
        error: 'Password does not meet security requirements',
        passwordErrors: passwordValidation.errors
      });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        error: 'User already exists'
      });
    }

    // Generate email verification token
    const verificationToken = crypto.randomBytes(32).toString('hex');
    const hashedToken = crypto.createHash('sha256').update(verificationToken).digest('hex');
    
    // Set token expiry to 24 hours
    const tokenExpiry = new Date();
    tokenExpiry.setHours(tokenExpiry.getHours() + 24);

    const user = await User.create({
      name,
      email,
      password,
      role,
      address,
      emailVerificationToken: hashedToken,
      emailVerificationExpires: tokenExpiry
    });

    // Generate verification URL
    const verificationUrl = `${process.env.FRONTEND_URL || 'http://localhost:5000'}/verify-email.html?token=${verificationToken}&email=${email}`;
    
    // Send verification email
    const emailTemplate = emailTemplates.verificationEmail(name, verificationUrl);
    const emailResult = await sendEmail(email, emailTemplate);
    
    if (!emailResult.success) {
      console.error('Failed to send verification email:', emailResult.error);
      // Don't fail registration if email fails, but log it
    }

    // Generate token for auto-login after registration
    const token = user.getSignedJwtToken();
    
    res.status(201).json({
      success: true,
      message: 'Registration successful! A verification email has been sent to your inbox.',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        isEmailVerified: user.isEmailVerified
      },
      token // Allow immediate login even without verification
    });
  } catch (err) {
    if (err.code === 11000) {
      return res.status(400).json({
        success: false,
        error: 'User already exists'
      });
    }
    
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

// @desc    Verify email
// @route   POST /api/auth/verify-email
// @access  Public
exports.verifyEmail = async (req, res) => {
  try {
    const { token, email } = req.body;

    if (!token || !email) {
      return res.status(400).json({
        success: false,
        error: 'Invalid verification link'
      });
    }

    // Hash the token to compare with stored hash
    const hashedToken = crypto.createHash('sha256').update(token).digest('hex');

    // Find user with matching token and email
    const user = await User.findOne({
      email,
      emailVerificationToken: hashedToken,
      emailVerificationExpires: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({
        success: false,
        error: 'Invalid or expired verification token'
      });
    }

    // Update user verification status
    user.isEmailVerified = true;
    user.verifiedAt = new Date();
    user.emailVerificationToken = null;
    user.emailVerificationExpires = null;
    await user.save();

    // Send success email
    const emailTemplate = emailTemplates.verificationSuccessEmail(user.name);
    await sendEmail(user.email, emailTemplate);

    res.status(200).json({
      success: true,
      message: 'Email verified successfully! You can now log in.'
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

// @desc    Resend verification email
// @route   POST /api/auth/resend-verification
// @access  Public
exports.resendVerification = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        success: false,
        error: 'Please provide an email address'
      });
    }

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    if (user.isEmailVerified) {
      return res.status(400).json({
        success: false,
        error: 'Email is already verified'
      });
    }

    // Generate new verification token
    const verificationToken = crypto.randomBytes(32).toString('hex');
    const hashedToken = crypto.createHash('sha256').update(verificationToken).digest('hex');
    
    // Set token expiry to 24 hours
    const tokenExpiry = new Date();
    tokenExpiry.setHours(tokenExpiry.getHours() + 24);

    // Update user with new token
    user.emailVerificationToken = hashedToken;
    user.emailVerificationExpires = tokenExpiry;
    await user.save();

    // Generate verification URL
    const verificationUrl = `${process.env.FRONTEND_URL || 'http://localhost:5000'}/verify-email.html?token=${verificationToken}&email=${email}`;
    
    // Send verification email
    const emailTemplate = emailTemplates.verificationEmail(user.name, verificationUrl);
    const emailResult = await sendEmail(email, emailTemplate);
    
    if (!emailResult.success) {
      return res.status(500).json({
        success: false,
        error: 'Failed to send verification email. Please try again later.'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Verification email sent successfully!'
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

// @desc    User login
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Please provide email and password'
      });
    }

    const user = await User.findOne({ email }).select('+password');

    if (!user || !await user.matchPassword(password)) {
      await handleFailedLogin(email);
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials',
        attemptsLeft: Math.max(0, (req.lockStatus?.attemptsLeft || 5) - 1)
      });
    }

    await handleSuccessfulLogin(email);
    sendTokenResponse(user, 200, res);
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

// @desc    Get current logged in user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    res.status(200).json({
      success: true,
      data: user
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
};

// @desc    Log out user
// @route   GET /api/auth/logout
// @access  Private
exports.logout = async (req, res) => {
  res.status(200).json({
    success: true,
    message: 'User logged out successfully'
  });
};

const sendTokenResponse = (user, statusCode, res) => {
  const token = user.getSignedJwtToken();

  res.status(statusCode).json({
    success: true,
    user: {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      isEmailVerified: user.isEmailVerified
    },
    token
  });
};

// Initialize email configuration on startup
(async () => {
  await verifyEmailConfig();
})();

// Export functions for testing
module.exports.validatePasswordPolicy = validatePasswordPolicy; 