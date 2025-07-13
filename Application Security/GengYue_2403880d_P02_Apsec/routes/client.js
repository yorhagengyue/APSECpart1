const express = require('express');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

// All routes require authentication and client role authorization
router.use(protect);
router.use(authorize('client', 'admin'));

// @desc    Client dashboard (root route to match API docs)
// @route   GET /api/client
// @access  Private/Client
router.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Client Dashboard',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      dashboard: 'client',
      permissions: ['view_profile', 'submit_requests', 'view_status']
    }
  });
});

// @desc    Client dashboard (alternative route)
// @route   GET /api/client/dashboard
// @access  Private/Client
router.get('/dashboard', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Client Dashboard',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      dashboard: 'client',
      permissions: ['view_profile', 'submit_requests', 'view_status']
    }
  });
});

module.exports = router; 