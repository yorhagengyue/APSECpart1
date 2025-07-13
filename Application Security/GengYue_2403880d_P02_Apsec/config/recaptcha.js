/**
 * Google reCAPTCHA Configuration
 * Provides server-side verification for reCAPTCHA v2
 */

const axios = require('axios');

// reCAPTCHA configuration
const RECAPTCHA_CONFIG = {
    // These should be in environment variables
    siteKey: process.env.RECAPTCHA_SITE_KEY || '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI', // Test key (always passes)
    secretKey: process.env.RECAPTCHA_SECRET_KEY || '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe', // Test key
    verifyUrl: 'https://www.google.com/recaptcha/api/siteverify'
};

/**
 * Verify reCAPTCHA response
 * @param {string} recaptchaResponse - The reCAPTCHA response token from client
 * @param {string} remoteIP - The user's IP address (optional)
 * @returns {Promise<Object>} - Verification result
 */
async function verifyRecaptcha(recaptchaResponse, remoteIP = null) {
    try {
        if (!recaptchaResponse) {
            return {
                success: false,
                error: 'reCAPTCHA response is missing'
            };
        }

        // Prepare verification data
        const verificationData = new URLSearchParams({
            secret: RECAPTCHA_CONFIG.secretKey,
            response: recaptchaResponse
        });

        if (remoteIP) {
            verificationData.append('remoteip', remoteIP);
        }

        // Send verification request to Google
        const response = await axios.post(RECAPTCHA_CONFIG.verifyUrl, verificationData, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        });

        const result = response.data;

        if (result.success) {
            return {
                success: true,
                score: result.score || null,
                action: result.action || null,
                hostname: result.hostname || null
            };
        } else {
            return {
                success: false,
                error: 'reCAPTCHA verification failed',
                errorCodes: result['error-codes'] || []
            };
        }
    } catch (error) {
        console.error('reCAPTCHA verification error:', error.message);
        return {
            success: false,
            error: 'Failed to verify reCAPTCHA',
            details: error.message
        };
    }
}

/**
 * Express middleware for reCAPTCHA verification
 * @param {boolean} required - Whether reCAPTCHA is required (default: true)
 * @returns {Function} - Express middleware function
 */
function recaptchaMiddleware(required = true) {
    return async (req, res, next) => {
        // Skip in test environment
        if (process.env.NODE_ENV === 'test') {
            return next();
        }

        const recaptchaResponse = req.body['g-recaptcha-response'] || req.body.recaptcha;
        
        // If reCAPTCHA is not required and not provided, continue
        if (!required && !recaptchaResponse) {
            return next();
        }

        // Get user's IP address
        const remoteIP = req.ip || req.connection.remoteAddress;

        // Verify reCAPTCHA
        const verificationResult = await verifyRecaptcha(recaptchaResponse, remoteIP);

        if (verificationResult.success) {
            // Store verification result in request for logging
            req.recaptchaVerified = true;
            req.recaptchaData = verificationResult;
            next();
        } else {
            // Log failed attempt
            console.log(`reCAPTCHA verification failed for IP ${remoteIP}:`, verificationResult.error);
            
            return res.status(400).json({
                success: false,
                error: 'reCAPTCHA verification failed. Please try again.',
                details: process.env.NODE_ENV === 'development' ? verificationResult : undefined
            });
        }
    };
}

module.exports = {
    RECAPTCHA_CONFIG,
    verifyRecaptcha,
    recaptchaMiddleware
}; 