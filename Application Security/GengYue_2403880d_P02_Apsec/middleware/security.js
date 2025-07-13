// Basic security headers
const securityHeaders = (req, res, next) => {
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    res.removeHeader('X-Powered-By');
    next();
};

// Simple session tracking (removed complex session management for MVP)

// Basic input sanitization
const sanitizeInput = (req, res, next) => {
    const sanitize = (obj) => {
        if (typeof obj === 'string') {
            return obj.replace(/<script.*?<\/script>/gi, '').replace(/javascript:/gi, '').trim();
        }
        if (typeof obj === 'object' && obj !== null) {
            for (const key in obj) {
                obj[key] = sanitize(obj[key]);
            }
        }
        return obj;
    };
    
    if (req.body) req.body = sanitize(req.body);
    if (req.query) req.query = sanitize(req.query);
    next();
};

// Simple security logging
const securityLogger = (req, res, next) => {
    if (req.url.includes('/api/auth/')) {
        console.log(`${new Date().toISOString()} - ${req.method} ${req.url} - IP: ${req.ip}`);
    }
    next();
};

module.exports = {
    securityHeaders,
    sanitizeInput,
    securityLogger
}; 