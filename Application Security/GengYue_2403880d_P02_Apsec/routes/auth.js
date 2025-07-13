const express = require('express');
const {
  register,
  login,
  getMe,
  logout,
  verifyEmail,
  resendVerification
} = require('../controllers/authController');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { loginRateLimiter } = require('../middleware/rateLimiter');
const { recaptchaMiddleware } = require('../config/recaptcha');

// Add reCAPTCHA to register and login routes
router.post('/register', recaptchaMiddleware(), register);
router.post('/login', recaptchaMiddleware(), loginRateLimiter, login);
router.get('/me', protect, getMe);
router.get('/profile', protect, getMe);
router.post('/logout', protect, logout);
router.get('/logout', protect, logout); // Keep GET for backwards compatibility

// Email verification routes
router.post('/verify-email', verifyEmail);
router.post('/resend-verification', resendVerification);

router.get('/test-token', protect, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Token is valid',
    user: {
      id: req.user._id,
      name: req.user.name,
      email: req.user.email,
      role: req.user.role
    }
  });
});

module.exports = router; 