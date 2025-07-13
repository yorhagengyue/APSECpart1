const nodemailer = require('nodemailer');

// Email configuration
const emailConfig = {
    service: 'gmail',
    host: 'smtp.gmail.com',
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
        user: process.env.EMAIL_USER || 'tpmswebservice@gmail.com',
        pass: process.env.EMAIL_APP_PASSWORD // App-specific password, NOT regular password
    }
};

// Create reusable transporter
const transporter = nodemailer.createTransport(emailConfig);

// Verify transporter configuration
const verifyEmailConfig = async () => {
    try {
        await transporter.verify();
        console.log('✅ Email server is ready to send messages');
        return true;
    } catch (error) {
        console.error('❌ Email configuration error:', error.message);
        console.log('\n⚠️  Please ensure:');
        console.log('1. EMAIL_APP_PASSWORD is set in .env file');
        console.log('2. You have generated an app-specific password from Gmail');
        console.log('3. 2-Step Verification is enabled on your Gmail account');
        return false;
    }
};

// Email templates
const emailTemplates = {
    verificationEmail: (name, verificationUrl) => ({
        subject: 'Verify Your Email - TechSecure',
        html: `
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                    .header { background-color: #007bff; color: white; padding: 20px; text-align: center; }
                    .content { background-color: #f8f9fa; padding: 30px; margin-top: 20px; }
                    .button { display: inline-block; padding: 12px 30px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }
                    .footer { text-align: center; margin-top: 30px; color: #6c757d; font-size: 14px; }
                    .warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; margin-top: 20px; border-radius: 5px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>Welcome to TechSecure!</h1>
                    </div>
                    <div class="content">
                        <h2>Hi ${name},</h2>
                        <p>Thank you for registering with TechSecure. To complete your registration, please verify your email address by clicking the button below:</p>
                        
                        <div style="text-align: center;">
                            <a href="${verificationUrl}" class="button">Verify Email Address</a>
                        </div>
                        
                        <p style="margin-top: 30px;">Or copy and paste this link into your browser:</p>
                        <p style="background-color: #e9ecef; padding: 10px; word-break: break-all;">${verificationUrl}</p>
                        
                        <div class="warning">
                            <strong>Important:</strong> This verification link will expire in 24 hours for security reasons.
                        </div>
                        
                        <p style="margin-top: 20px;">If you didn't create an account with TechSecure, please ignore this email.</p>
                    </div>
                    <div class="footer">
                        <p>This is an automated message from TechSecure. Please do not reply to this email.</p>
                        <p>&copy; 2024 TechSecure. All rights reserved.</p>
                    </div>
                </div>
            </body>
            </html>
        `,
        text: `
Hi ${name},

Thank you for registering with TechSecure. To complete your registration, please verify your email address by clicking the link below:

${verificationUrl}

This verification link will expire in 24 hours for security reasons.

If you didn't create an account with TechSecure, please ignore this email.

Best regards,
The TechSecure Team
        `
    }),
    
    verificationSuccessEmail: (name) => ({
        subject: 'Email Verified Successfully - TechSecure',
        html: `
            <!DOCTYPE html>
            <html>
            <head>
                <style>
                    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                    .header { background-color: #28a745; color: white; padding: 20px; text-align: center; }
                    .content { background-color: #f8f9fa; padding: 30px; margin-top: 20px; }
                    .button { display: inline-block; padding: 12px 30px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }
                    .footer { text-align: center; margin-top: 30px; color: #6c757d; font-size: 14px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>Email Verified!</h1>
                    </div>
                    <div class="content">
                        <h2>Congratulations ${name}!</h2>
                        <p>Your email has been successfully verified. You can now log in to your TechSecure account with full access.</p>
                        
                        <div style="text-align: center;">
                            <a href="${process.env.FRONTEND_URL || 'http://localhost:5000'}/login.html" class="button">Login to Your Account</a>
                        </div>
                        
                        <p style="margin-top: 30px;">Thank you for choosing TechSecure for your security needs!</p>
                    </div>
                    <div class="footer">
                        <p>&copy; 2024 TechSecure. All rights reserved.</p>
                    </div>
                </div>
            </body>
            </html>
        `,
        text: `
Hi ${name},

Congratulations! Your email has been successfully verified. You can now log in to your TechSecure account with full access.

Login here: ${process.env.FRONTEND_URL || 'http://localhost:5000'}/login.html

Thank you for choosing TechSecure!

Best regards,
The TechSecure Team
        `
    })
};

// Send email function
const sendEmail = async (to, template) => {
    try {
        const info = await transporter.sendMail({
            from: `"TechSecure" <${emailConfig.auth.user}>`,
            to: to,
            subject: template.subject,
            text: template.text,
            html: template.html
        });
        
        console.log('Email sent successfully:', info.messageId);
        return { success: true, messageId: info.messageId };
    } catch (error) {
        console.error('Error sending email:', error);
        return { success: false, error: error.message };
    }
};

module.exports = {
    verifyEmailConfig,
    sendEmail,
    emailTemplates
}; 