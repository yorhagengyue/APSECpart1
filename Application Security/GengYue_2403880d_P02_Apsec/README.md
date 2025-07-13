# TechSecure Project

This is a secure authentication and authorization system for TechSecure company.

## Roles

| Feature | Client | Analyst | Manager | Admin |
|---------|--------|---------|---------|-------|
| View Dashboard | ✓ | ✓ | ✓ | ✓ |
| View Profile | ✓ | ✓ | ✓ | ✓ |
| Submit Requests | ✓ | ✗ | ✗ | ✗ |
| Analyze Data | ✗ | ✓ | ✗ | ✓ |
| Manage Requests | ✗ | ✗ | ✓ | ✓ |
| User Management | ✗ | ✗ | ✗ | ✓ |
| System Settings | ✗ | ✗ | ✗ | ✓ |

## Authentication

### Technologies Used
- **Backend**: Node.js, Express.js, MongoDB with Mongoose ODM
- **Frontend**: HTML5, CSS3, JavaScript (ES6+), Bootstrap 5
- **Authentication**: JWT (JSON Web Tokens) with 24-hour expiration
- **Security Libraries**: bcryptjs, Helmet.js, express-rate-limit, DOMPurify
- **Additional**: Nodemailer, node-forge (SSL), Chart.js

### Security Features
- **Password Security**: bcrypt hashing with salt rounds
- **Strong Password Policy**: 8+ chars, uppercase, lowercase, numbers, special chars
- **Google reCAPTCHA v2**: Bot protection on login/register
- **Rate Limiting**: 5 login attempts per 15 minutes per IP
- **Input Sanitization**: XSS protection with DOMPurify
- **Security Headers**: Helmet.js (X-Frame-Options, CSP, etc.)
- **SSL/TLS Support**: HTTPS with self-signed certificates
- **Email Verification**: Optional email verification system
- **Session Security**: JWT stored in localStorage with expiration

## Authentication Flow

1. **User Registration**
   - User provides name, email, password, and role
   - Frontend validates password policy
   - Backend verifies data and checks for duplicates
   - Password hashed with bcrypt before storage
   - Verification email sent (optional)
   - User auto-logged in after registration

2. **User Login**
   - User enters email and password
   - reCAPTCHA verification required
   - Backend validates credentials
   - Rate limiting prevents brute force
   - JWT token generated on success
   - Token stored in localStorage

3. **Accessing Protected Routes**
   - JWT token validated on each request
   - Role-based access control enforced
   - 401/403 errors redirect to login
   - Token expiration handled gracefully

## API Routes

| Name | URL | Method | Description |
|------|-----|--------|-------------|
| Register | `/api/auth/register` | POST | User registration with email verification |
| Login | `/api/auth/login` | POST | User authentication with reCAPTCHA |
| Get Profile | `/api/auth/me` | GET | Get current user information |
| Logout | `/api/auth/logout` | GET/POST | Clear user session |
| Verify Email | `/api/auth/verify-email` | POST | Verify email with token |
| Resend Email | `/api/auth/resend-verification` | POST | Resend verification email |
| Admin Dashboard | `/api/admin/*` | ALL | Admin-only endpoints |
| Manager Dashboard | `/api/manager/*` | ALL | Manager-only endpoints |
| Analyst Dashboard | `/api/analyst/*` | ALL | Analyst-only endpoints |
| Client Dashboard | `/api/client/*` | ALL | Client-only endpoints |

## Quick Start

1. **Clone and Install**
   ```bash
   git clone <repository>
   cd GengYue_2403880d_P02_Apsec
   npm install
   ```

2. **Configure Environment**
   ```bash
   # Create .env file with:
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_secret_key
   EMAIL_USER=tpmswebservice@gmail.com
   EMAIL_APP_PASSWORD=your_gmail_app_password
   ```

3. **Generate SSL Certificate (Optional)**
   ```bash
   npm run cert:generate
   ```

4. **Start Server**
   ```bash
   # HTTP
   npm start
   
   # HTTPS
   npm run start:https
   ```

5. **Access Application**
   - HTTP: http://localhost:5000
   - HTTPS: https://localhost:5443

## Default Users

| Email | Password | Role |
|-------|----------|------|
| admin@techsecure.com | Admin@123 | Admin |
| manager@techsecure.com | Manager@123 | Manager |
| analyst@techsecure.com | Analyst@123 | Analyst |
| client@techsecure.com | Client@123 | Client |

## Testing

```bash
npm test  # Run all tests
```

## Security Documentation

Visit these pages when server is running:
- `/ssl-setup.html` - SSL/TLS Configuration Guide
- `/recaptcha-setup.html` - reCAPTCHA Setup Guide
- `/email-setup.html` - Email Verification Setup

## License

This project is for educational purposes - APSEC Course Assignment 