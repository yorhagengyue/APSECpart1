const express = require('express');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

// All routes require authentication and analyst role authorization
router.use(protect);
router.use(authorize('analyst', 'admin'));

// @desc    Analyst dashboard (root route to match API docs)
// @route   GET /api/analyst
// @access  Private/Analyst
router.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Analyst Dashboard',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      dashboard: 'analyst',
      permissions: ['view_data', 'create_reports', 'analyze_trends']
    }
  });
});

// @desc    Analyst dashboard (alternative route)
// @route   GET /api/analyst/dashboard
// @access  Private/Analyst
router.get('/dashboard', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Analyst Dashboard',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      dashboard: 'analyst',
      permissions: ['view_data', 'create_reports', 'analyze_trends']
    }
  });
});

module.exports = router; 