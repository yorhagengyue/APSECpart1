/**
 * register.js - Registration page functionality
 * Handles user registration form submission and validation
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
    
    // Get registration form element
    const registerForm = document.getElementById('registerForm');
    
    // Add form submit event listener
    registerForm.addEventListener('submit', handleRegister);
    
    // Add password confirmation validation
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    
    // Real-time password strength checking
    passwordInput.addEventListener('input', function() {
        const userInfo = {
            name: document.getElementById('name').value,
            email: document.getElementById('email').value
        };
        displayPasswordStrength(this.value, 'passwordStrength', userInfo);
    });
    
    // Validate password match on input
    confirmPasswordInput.addEventListener('input', function() {
        if (this.value !== passwordInput.value) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
    
    // Add real-time validation to form fields
    addRealtimeValidation('name', (value) => validateName(value, 'Full Name'));
    addRealtimeValidation('email', validateEmail);
    addRealtimeValidation('role', (value) => validateRequired(value, 'Role'));
});

/**
 * Handle registration form submission
 * @param {Event} event - Form submit event
 */
async function handleRegister(event) {
    // Prevent default form submission
    event.preventDefault();
    
    // Get form elements
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const roleSelect = document.getElementById('role');
    
    // Get form values
    const name = nameInput.value.trim();
    const email = emailInput.value.trim();
    const password = passwordInput.value;
    const confirmPassword = confirmPasswordInput.value;
    const role = roleSelect.value;
    
    // Validate form data including password policy
    if (!validateRegistrationForm(name, email, password, confirmPassword, role)) {
        return;
    }
    
    // Additional password policy validation
    const userInfo = { name, email };
    const passwordValidation = validatePasswordPolicy(password, userInfo);
    if (!passwordValidation.isValid) {
        showError('Password does not meet security requirements: ' + passwordValidation.errors.join(', '));
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
    submitButton.textContent = 'Registering...';
    
    try {
        // Make registration API request
        const response = await fetch('/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                name: name,
                email: email,
                password: password,
                'g-recaptcha-response': recaptchaResponse,
                role: role
            })
        });
        
        // Parse response
        const data = await response.json();
        
        // Check if registration was successful
        if (response.ok && data.success) {
            // Show success message
            showSuccess('Registration successful! A verification email has been sent to your inbox.');
            
            // Show additional info after 1 second
            setTimeout(() => {
                showInfo(`You can verify your email later. Redirecting to dashboard...`);
            }, 1000);
            
            // Save token and user data (auto-login after registration)
            if (data.token) {
                saveToken(data.token);
                saveUserData(data.user);
                
                // Redirect to appropriate dashboard after short delay
                setTimeout(() => {
                    redirectByRole(data.user.role);
                }, 3000);
            } else {
                // Redirect to login if no token
                setTimeout(() => {
                    window.location.href = '/login.html';
                }, 3000);
            }
        } else {
            // Show error message
            const errorMessage = data.error || 'Registration failed. Please try again.';
            showError(errorMessage);
            
            // Re-enable submit button
            submitButton.disabled = false;
            submitButton.textContent = 'Register';
        }
    } catch (error) {
        // Handle network or other errors
        console.error('Registration error:', error);
        showError('Network error. Please check your connection and try again.');
        
        // Re-enable submit button
        submitButton.disabled = false;
        submitButton.textContent = 'Register';
    }
}

/**
 * Validate registration form data
 * @param {string} name - User's name
 * @param {string} email - User's email
 * @param {string} password - User's password
 * @param {string} confirmPassword - Password confirmation
 * @param {string} role - Selected role
 * @returns {boolean} - True if all data is valid
 */
function validateRegistrationForm(name, email, password, confirmPassword, role) {
    // Clear previous validation errors
    clearValidationErrors();
    
    let isValid = true;
    
    // Validate name
    if (!name || name.length < 2) {
        document.getElementById('name').classList.add('is-invalid');
        showError('Name must be at least 2 characters long');
        isValid = false;
    }
    
    // Validate email
    if (!validateEmail(email)) {
        document.getElementById('email').classList.add('is-invalid');
        showError('Please enter a valid email address');
        isValid = false;
    }
    
    // Validate password using password policy
    const passwordValidation = validatePasswordPolicy(password);
    if (!passwordValidation.isValid) {
        document.getElementById('password').classList.add('is-invalid');
        showError(passwordValidation.errors.join(', '));
        isValid = false;
    }
    
    // Validate password match
    if (password !== confirmPassword) {
        document.getElementById('confirmPassword').classList.add('is-invalid');
        showError('Passwords do not match');
        isValid = false;
    }
    
    // Validate role selection
    if (!role) {
        document.getElementById('role').classList.add('is-invalid');
        showError('Please select a role');
        isValid = false;
    }
    
    return isValid;
}

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean} - True if email is valid
 */
function validateEmail(email) {
    // Email validation regex
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Clear all form validation errors
 */
function clearValidationErrors() {
    // Remove all validation error classes
    const inputs = document.querySelectorAll('.is-invalid');
    inputs.forEach(input => {
        input.classList.remove('is-invalid');
    });
}

// Add real-time validation listeners
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
    
    // Name validation on blur
    const nameInput = document.getElementById('name');
    nameInput.addEventListener('blur', function() {
        if (this.value.trim().length < 2) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
    
    // Password length validation on blur
    const passwordInput = document.getElementById('password');
    passwordInput.addEventListener('blur', function() {
        if (this.value.length < 6) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
    
    // Clear validation on input
    const inputs = document.querySelectorAll('input, select');
    inputs.forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });
    });
}); 