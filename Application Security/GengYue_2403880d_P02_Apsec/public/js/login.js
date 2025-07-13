/**
 * login.js - Login page functionality
 * Handles user login form submission and authentication
 */

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Check if user is already logged in
    if (isAuthenticated()) {
        // Redirect to appropriate dashboard
        const role = getUserRole();
        redirectByRole(role);
        return;
    }
    
    // Get login form element
    const loginForm = document.getElementById('loginForm');
    
    // Add form submit event listener
    loginForm.addEventListener('submit', handleLogin);
});

/**
 * Handle login form submission
 * @param {Event} event - Form submit event
 */
async function handleLogin(event) {
    // Prevent default form submission
    event.preventDefault();
    
    // Get form elements
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    
    // Get form values
    const email = emailInput.value.trim();
    const password = passwordInput.value;
    
    // Basic validation
    if (!email || !password) {
        showError('Please enter both email and password');
        return;
    }
    
    // Check reCAPTCHA
    const recaptchaResponse = typeof grecaptcha !== 'undefined' ? grecaptcha.getResponse() : null;
    
    if (!recaptchaResponse) {
        showError('Please complete the reCAPTCHA verification');
        return;
    }
    
    // Disable submit button to prevent multiple submissions
    const submitButton = event.target.querySelector('button[type="submit"]');
    submitButton.disabled = true;
    submitButton.textContent = 'Logging in...';
    
    try {
        // Make login API request
        const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                email: email,
                password: password,
                'g-recaptcha-response': recaptchaResponse
            })
        });
        
        // Parse response
        const data = await response.json();
        
        // Check if login was successful
        if (response.ok && data.success) {
            // Show success message
            showSuccess('Login successful! Redirecting...');
            
            // Save token and user data
            saveToken(data.token);
            saveUserData(data.user);
            
            // Redirect based on role after short delay
            setTimeout(() => {
                redirectByRole(data.user.role);
            }, 1000);
        } else {
            // Show error message
            const errorMessage = data.error || 'Login failed. Please try again.';
            showError(errorMessage);
            
            // Re-enable submit button
            submitButton.disabled = false;
            submitButton.textContent = 'Login';
        }
    } catch (error) {
        // Handle network or other errors
        console.error('Login error:', error);
        showError('Network error. Please check your connection and try again.');
        
        // Re-enable submit button
        submitButton.disabled = false;
        submitButton.textContent = 'Login';
    }
}

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean} - True if email is valid
 */
function validateEmail(email) {
    // Simple email validation regex
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Clear form validation errors
 */
function clearValidationErrors() {
    // Remove all validation error classes
    const inputs = document.querySelectorAll('.is-invalid');
    inputs.forEach(input => {
        input.classList.remove('is-invalid');
    });
}

// Add input event listeners for real-time validation
document.addEventListener('DOMContentLoaded', function() {
    // Email validation on blur
    const emailInput = document.getElementById('email');
    emailInput.addEventListener('blur', function() {
        if (!validateEmail(this.value)) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
    
    // Clear validation on input
    const inputs = document.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });
    });
});

// Resend verification email function
async function resendVerification(email) {
    try {
        showInfo('Sending verification email...');
        
        const response = await fetch('/api/auth/resend-verification', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email })
        });
        
        const data = await response.json();
        
        if (response.ok) {
            showSuccess('Verification email sent! Please check your inbox and spam folder.');
        } else {
            showError(data.error || 'Failed to send verification email.');
        }
    } catch (error) {
        showError('Network error. Please try again later.');
    }
}

// Make resendVerification available globally
window.resendVerification = resendVerification; 