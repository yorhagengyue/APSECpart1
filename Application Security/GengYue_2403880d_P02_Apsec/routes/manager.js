const express = require('express');
const { protect, authorize } = require('../middleware/auth');
const User = require('../models/User');

const router = express.Router();

// All routes require authentication and manager role authorization
router.use(protect);
router.use(authorize('manager', 'admin'));

// @desc    Manager dashboard (root route to match API docs)
// @route   GET /api/manager
// @access  Private/Manager
router.get('/', async (req, res) => {
  try {
    // Get team statistics
    const teamMembers = await User.find({ role: { $in: ['analyst', 'client'] } }).select('-password');
    const totalTeamMembers = teamMembers.length;
    
    // Mock data for demonstration
    const dashboardData = {
      teamSize: totalTeamMembers,
      pendingRequests: 5,
      availableReports: 8,
      systemStatus: 'Online',
      recentActivity: [
        { action: 'New team member added', time: '2 hours ago' },
        { action: 'Report generated', time: '4 hours ago' },
        { action: 'Request approved', time: '1 day ago' }
      ]
    };

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
        permissions: ['view_reports', 'manage_team', 'approve_requests'],
        stats: dashboardData
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error'
    });
  }
});

// @desc    Manager dashboard (alternative route)
// @route   GET /api/manager/dashboard
// @access  Private/Manager
router.get('/dashboard', async (req, res) => {
  try {
    // Get team statistics
    const teamMembers = await User.find({ role: { $in: ['analyst', 'client'] } }).select('-password');
    const totalTeamMembers = teamMembers.length;
    
    // Mock data for demonstration
    const dashboardData = {
      teamSize: totalTeamMembers,
      pendingRequests: 5,
      availableReports: 8,
      systemStatus: 'Online',
      recentActivity: [
        { action: 'New team member added', time: '2 hours ago' },
        { action: 'Report generated', time: '4 hours ago' },
        { action: 'Request approved', time: '1 day ago' }
      ]
    };

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
        permissions: ['view_reports', 'manage_team', 'approve_requests'],
        stats: dashboardData
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error'
    });
  }
});

// @desc    Get team members
// @route   GET /api/manager/team
// @access  Private/Manager
router.get('/team', async (req, res) => {
  try {
    const teamMembers = await User.find({ 
      role: { $in: ['analyst', 'client'] } 
    }).select('-password');

    // Add mock performance data
    const teamWithPerformance = teamMembers.map(member => ({
      ...member.toObject(),
      department: member.role === 'analyst' ? 'Analysis' : 'Operations',
      status: 'Active',
      performance: Math.floor(Math.random() * 20) + 80, // Random performance 80-100%
      lastActive: new Date(Date.now() - Math.floor(Math.random() * 7) * 24 * 60 * 60 * 1000)
    }));

    res.status(200).json({
      success: true,
      count: teamWithPerformance.length,
      data: teamWithPerformance
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error'
    });
  }
});

// @desc    Get reports
// @route   GET /api/manager/reports
// @access  Private/Manager
router.get('/reports', (req, res) => {
  // Mock reports data
  const reports = [
    {
      id: 1,
      title: 'Monthly Performance Report',
      type: 'Performance',
      date: new Date().toISOString().split('T')[0],
      status: 'Completed'
    },
    {
      id: 2,
      title: 'Security Analysis Report',
      type: 'Security',
      date: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      status: 'Completed'
    },
    {
      id: 3,
      title: 'Team Productivity Report',
      type: 'Productivity',
      date: new Date().toISOString().split('T')[0],
      status: 'In Progress'
    }
  ];

  res.status(200).json({
    success: true,
    count: reports.length,
    data: reports
  });
});

// @desc    Get pending requests
// @route   GET /api/manager/requests
// @access  Private/Manager
router.get('/requests', (req, res) => {
  // Mock pending requests
  const requests = [
    {
      id: 1,
      type: 'Access Request',
      requestedBy: 'john.doe@techsecure.com',
      description: 'Request for elevated analysis permissions',
      date: new Date().toISOString().split('T')[0],
      priority: 'Medium'
    },
    {
      id: 2,
      type: 'Resource Request',
      requestedBy: 'jane.smith@techsecure.com',
      description: 'Additional storage space for client data',
      date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      priority: 'High'
    }
  ];

  res.status(200).json({
    success: true,
    count: requests.length,
    data: requests
  });
});

// @desc    Approve request
// @route   PUT /api/manager/requests/:id/approve
// @access  Private/Manager
router.put('/requests/:id/approve', (req, res) => {
  const requestId = req.params.id;
  
  // Mock approval process
  res.status(200).json({
    success: true,
    message: `Request ${requestId} approved successfully`,
    data: {
      requestId,
      status: 'Approved',
      approvedBy: req.user.name,
      approvedAt: new Date()
    }
  });
});

module.exports = router; 