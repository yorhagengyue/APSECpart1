const express = require('express');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

// All routes require authentication and manager role authorization
router.use(protect);
router.use(authorize('manager', 'admin'));

// @desc    Manager dashboard
// @route   GET /api/manager/dashboard
// @access  Private/Manager
router.get('/dashboard', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Manager Dashboard',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    },
    data: {
      dashboard: 'manager',
      permissions: ['view_reports', 'manage_team', 'approve_requests']
    }
  });
});

module.exports = router; 