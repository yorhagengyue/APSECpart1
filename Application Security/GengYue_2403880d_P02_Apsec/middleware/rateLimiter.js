const mongoose = require('mongoose');

// Simple login attempt tracking
const LoginAttemptSchema = new mongoose.Schema({
    email: { type: String, required: true, index: true },
    attempts: { type: Number, default: 0 },
    lastAttempt: { type: Date, default: Date.now },
    lockedUntil: { type: Date, default: null }
});

LoginAttemptSchema.index({ lastAttempt: 1 }, { expireAfterSeconds: 86400 });
const LoginAttempt = mongoose.model('LoginAttempt', LoginAttemptSchema);

const MAX_ATTEMPTS = 5;
const LOCKOUT_TIME = 15 * 60 * 1000; // 15 minutes

async function checkAccountLock(email) {
    try {
        const attempt = await LoginAttempt.findOne({ email });
        
        if (!attempt) {
            return { isLocked: false, attemptsLeft: MAX_ATTEMPTS };
        }
        
        // Check if lockout expired
        if (attempt.lockedUntil && attempt.lockedUntil > new Date()) {
            const remainingTime = Math.ceil((attempt.lockedUntil - new Date()) / 1000 / 60);
            return { isLocked: true, remainingTime };
        }
        
        // Reset if lockout expired
        if (attempt.lockedUntil && attempt.lockedUntil <= new Date()) {
            await LoginAttempt.updateOne({ email }, { $unset: { lockedUntil: 1 }, $set: { attempts: 0 } });
            return { isLocked: false, attemptsLeft: MAX_ATTEMPTS };
        }
        
        return { isLocked: false, attemptsLeft: Math.max(0, MAX_ATTEMPTS - attempt.attempts) };
        
    } catch (error) {
        console.error('Error checking account lock:', error);
        return { isLocked: false, attemptsLeft: MAX_ATTEMPTS };
    }
}

async function recordFailedAttempt(email) {
    try {
        let attempt = await LoginAttempt.findOne({ email });
        
        if (!attempt) {
            attempt = new LoginAttempt({ email, attempts: 0 });
        }
        
        attempt.attempts += 1;
        attempt.lastAttempt = new Date();
        
        if (attempt.attempts >= MAX_ATTEMPTS) {
            attempt.lockedUntil = new Date(Date.now() + LOCKOUT_TIME);
        }
        
        await attempt.save();
        console.log(`Failed login for ${email}. Attempts: ${attempt.attempts}`);
        
    } catch (error) {
        console.error('Error recording failed attempt:', error);
    }
}

async function recordSuccessfulLogin(email) {
    try {
        await LoginAttempt.deleteOne({ email });
    } catch (error) {
        console.error('Error recording successful login:', error);
    }
}

const loginRateLimiter = async (req, res, next) => {
    try {
        const email = req.body.email;
        
        if (!email) {
            return res.status(400).json({ success: false, error: 'Email is required' });
        }
        
        const lockStatus = await checkAccountLock(email);
        
        if (lockStatus.isLocked) {
            return res.status(429).json({
                success: false,
                error: `Account locked. Try again in ${lockStatus.remainingTime} minutes.`,
                remainingMinutes: lockStatus.remainingTime
            });
        }
        
        req.lockStatus = lockStatus;
        next();
        
    } catch (error) {
        console.error('Rate limiter error:', error);
        next();
    }
};

const handleFailedLogin = async (email) => {
    await recordFailedAttempt(email);
};

const handleSuccessfulLogin = async (email) => {
    await recordSuccessfulLogin(email);
};

module.exports = {
    loginRateLimiter,
    handleFailedLogin,
    handleSuccessfulLogin
}; 