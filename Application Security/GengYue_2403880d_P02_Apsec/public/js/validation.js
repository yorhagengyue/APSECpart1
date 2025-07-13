/**
 * Frontend validation utilities
 * Provides comprehensive input validation for all forms
 */

// Email validation regex
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Phone number validation (international format)
const PHONE_REGEX = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{4,6}$/;

// URL validation
const URL_REGEX = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;

/**
 * Validate email format
 * @param {string} email - Email address to validate
 * @returns {object} - Validation result with isValid and error message
 */
function validateEmail(email) {
    if (!email || email.trim() === '') {
        return { isValid: false, error: 'Email is required' };
    }
    
    if (!EMAIL_REGEX.test(email)) {
        return { isValid: false, error: 'Invalid email format' };
    }
    
    return { isValid: true, error: null };
}

/**
 * Validate name (first/last name)
 * @param {string} name - Name to validate
 * @param {string} fieldName - Field name for error message
 * @returns {object} - Validation result
 */
function validateName(name, fieldName = 'Name') {
    if (!name || name.trim() === '') {
        return { isValid: false, error: `${fieldName} is required` };
    }
    
    if (name.trim().length < 2) {
        return { isValid: false, error: `${fieldName} must be at least 2 characters` };
    }
    
    if (name.trim().length > 50) {
        return { isValid: false, error: `${fieldName} must be less than 50 characters` };
    }
    
    // Check for invalid characters
    if (!/^[a-zA-Z\s'-]+$/.test(name)) {
        return { isValid: false, error: `${fieldName} contains invalid characters` };
    }
    
    return { isValid: true, error: null };
}

/**
 * Validate phone number
 * @param {string} phone - Phone number to validate
 * @returns {object} - Validation result
 */
function validatePhone(phone) {
    if (!phone || phone.trim() === '') {
        return { isValid: true, error: null }; // Phone is optional
    }
    
    if (!PHONE_REGEX.test(phone)) {
        return { isValid: false, error: 'Invalid phone number format' };
    }
    
    return { isValid: true, error: null };
}

/**
 * Validate URL
 * @param {string} url - URL to validate
 * @returns {object} - Validation result
 */
function validateURL(url) {
    if (!url || url.trim() === '') {
        return { isValid: true, error: null }; // URL is optional
    }
    
    if (!URL_REGEX.test(url)) {
        return { isValid: false, error: 'Invalid URL format' };
    }
    
    return { isValid: true, error: null };
}

/**
 * Validate required field
 * @param {string} value - Value to validate
 * @param {string} fieldName - Field name for error message
 * @returns {object} - Validation result
 */
function validateRequired(value, fieldName) {
    if (!value || value.trim() === '') {
        return { isValid: false, error: `${fieldName} is required` };
    }
    
    return { isValid: true, error: null };
}

/**
 * Validate minimum length
 * @param {string} value - Value to validate
 * @param {number} minLength - Minimum length
 * @param {string} fieldName - Field name for error message
 * @returns {object} - Validation result
 */
function validateMinLength(value, minLength, fieldName) {
    if (!value || value.length < minLength) {
        return { isValid: false, error: `${fieldName} must be at least ${minLength} characters` };
    }
    
    return { isValid: true, error: null };
}

/**
 * Validate maximum length
 * @param {string} value - Value to validate
 * @param {number} maxLength - Maximum length
 * @param {string} fieldName - Field name for error message
 * @returns {object} - Validation result
 */
function validateMaxLength(value, maxLength, fieldName) {
    if (value && value.length > maxLength) {
        return { isValid: false, error: `${fieldName} must be less than ${maxLength} characters` };
    }
    
    return { isValid: true, error: null };
}

/**
 * Display validation error on form field
 * @param {string} fieldId - ID of the form field
 * @param {string} error - Error message to display
 */
function showFieldError(fieldId, error) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    
    // Add error class to field
    field.classList.add('is-invalid');
    field.classList.remove('is-valid');
    
    // Find or create error message element
    let errorElement = field.nextElementSibling;
    if (!errorElement || !errorElement.classList.contains('invalid-feedback')) {
        errorElement = document.createElement('div');
        errorElement.className = 'invalid-feedback';
        field.parentNode.insertBefore(errorElement, field.nextSibling);
    }
    
    errorElement.textContent = error;
}

/**
 * Clear validation error on form field
 * @param {string} fieldId - ID of the form field
 */
function clearFieldError(fieldId) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    
    // Remove error class
    field.classList.remove('is-invalid');
    
    // Find and hide error message
    const errorElement = field.nextElementSibling;
    if (errorElement && errorElement.classList.contains('invalid-feedback')) {
        errorElement.textContent = '';
    }
}

/**
 * Show field as valid
 * @param {string} fieldId - ID of the form field
 */
function showFieldValid(fieldId) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    
    field.classList.remove('is-invalid');
    field.classList.add('is-valid');
}

/**
 * Validate entire form
 * @param {object} validations - Object with field validations
 * @returns {boolean} - True if all validations pass
 */
function validateForm(validations) {
    let isValid = true;
    
    for (const [fieldId, validation] of Object.entries(validations)) {
        if (!validation.isValid) {
            showFieldError(fieldId, validation.error);
            isValid = false;
        } else {
            clearFieldError(fieldId);
            showFieldValid(fieldId);
        }
    }
    
    return isValid;
}

/**
 * Add real-time validation to a field
 * @param {string} fieldId - ID of the form field
 * @param {function} validationFn - Validation function to run
 */
function addRealtimeValidation(fieldId, validationFn) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    
    // Validate on blur
    field.addEventListener('blur', () => {
        const result = validationFn(field.value);
        if (!result.isValid) {
            showFieldError(fieldId, result.error);
        } else {
            clearFieldError(fieldId);
            showFieldValid(fieldId);
        }
    });
    
    // Clear error on input
    field.addEventListener('input', () => {
        if (field.classList.contains('is-invalid')) {
            clearFieldError(fieldId);
        }
    });
} 