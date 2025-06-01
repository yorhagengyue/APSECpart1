const express = require('express');
const { protect, authorize } = require('../middleware/auth');
const User = require('../models/User');

const router = express.Router();

// @desc    Register President
// @route   POST /register-president
// @access  Public
router.post('/register-president', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const user = await User.create({
      name: username || 'President User',
      username,
      email,
      password,
      role: 'president'
    });

    const token = user.getSignedJwtToken();

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
});

// @desc    Register Secretary
// @route   POST /register-secretary
// @access  Public
router.post('/register-secretary', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const user = await User.create({
      name: username || 'Secretary User',
      username,
      email,
      password,
      role: 'secretary'
    });

    const token = user.getSignedJwtToken();

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
});

// @desc    Register Treasurer
// @route   POST /register-treasurer
// @access  Public
router.post('/register-treasurer', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const user = await User.create({
      name: username || 'Treasurer User',
      username,
      email,
      password,
      role: 'treasurer'
    });

    const token = user.getSignedJwtToken();

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
});

// @desc    Register Member
// @route   POST /register-member
// @access  Public
router.post('/register-member', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const user = await User.create({
      name: username || 'Member User',
      username,
      email,
      password,
      role: 'member'
    });

    const token = user.getSignedJwtToken();

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
});

// @desc    Login user
// @route   POST /login
// @access  Public
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Please provide email and password'
      });
    }

    const user = await User.findOne({ email }).select('+password');

    if (!user) {
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials'
      });
    }

    const isMatch = await user.matchPassword(password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials'
      });
    }

    const token = user.getSignedJwtToken();

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
});

// @desc    Logout user
// @route   POST /logout
// @access  Private
router.post('/logout', protect, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'User logged out successfully'
  });
});

// @desc    Public access endpoint
// @route   GET /public
// @access  Public
router.get('/public', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'This is a public endpoint accessible to everyone',
    data: {
      timestamp: new Date().toISOString(),
      info: 'No authentication required'
    }
  });
});

// @desc    President protected route
// @route   GET /president-protected
// @access  Private/President
router.get('/president-protected', protect, authorize('president'), (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to President Protected Area',
    user: {
      id: req.user._id,
      name: req.user.name,
      username: req.user.username,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      area: 'president-protected',
      permissions: ['executive_decisions', 'full_access', 'strategic_planning']
    }
  });
});

// @desc    Secretary protected route
// @route   GET /secretary-protected
// @access  Private/Secretary
router.get('/secretary-protected', protect, authorize('secretary', 'president'), (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Secretary Protected Area',
    user: {
      id: req.user._id,
      name: req.user.name,
      username: req.user.username,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      area: 'secretary-protected',
      permissions: ['document_management', 'meeting_coordination', 'communication']
    }
  });
});

// @desc    Treasurer protected route
// @route   GET /treasurer-protected
// @access  Private/Treasurer
router.get('/treasurer-protected', protect, authorize('treasurer', 'president'), (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Treasurer Protected Area',
    user: {
      id: req.user._id,
      name: req.user.name,
      username: req.user.username,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      area: 'treasurer-protected',
      permissions: ['financial_management', 'budget_control', 'expense_tracking']
    }
  });
});

// @desc    Member protected route
// @route   GET /member-protected
// @access  Private/Member
router.get('/member-protected', protect, authorize('member', 'secretary', 'treasurer', 'president'), (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Member Protected Area',
    user: {
      id: req.user._id,
      name: req.user.name,
      username: req.user.username,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      area: 'member-protected',
      permissions: ['basic_access', 'view_announcements', 'participate_activities']
    }
  });
});

module.exports = router; 