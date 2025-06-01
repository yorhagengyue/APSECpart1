const express = require('express');
const router = express.Router();
const { protect, authorize } = require('../middleware/auth');
const User = require('../models/User');

// @desc    Admin dashboard
// @route   GET /api/admin/dashboard
// @access  Private/Admin
router.get('/dashboard', protect, authorize('admin'), (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Admin Dashboard',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      dashboard: 'admin',
      permissions: ['full_access', 'manage_users', 'system_settings']
    }
  });
});

// @desc    Get all users
// @route   GET /api/admin/users
// @access  Private/Admin
router.get('/users', protect, authorize('admin'), async (req, res) => {
  try {
    const users = await User.find({}).select('-password');
    
    res.status(200).json({
      success: true,
      count: users.length,
      data: users
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error'
    });
  }
});

module.exports = router; 