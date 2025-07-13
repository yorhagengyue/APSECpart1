/**
 * auth.js - Authentication utility functions
 * This file contains common authentication functions used across the application
 * Including JWT token management, API calls, and user session handling
 */

// API Base URL - Since frontend and backend are integrated, use relative paths
const API_BASE_URL = '';

/**
 * Store JWT token in localStorage
 * @param {string} token - JWT token received from server
 */
function saveToken(token) {
    // Store token in localStorage for persistent authentication
    localStorage.setItem('authToken', token);
}

/**
 * Get JWT token from localStorage
 * @returns {string|null} - JWT token or null if not found
 */
function getToken() {
    // Retrieve token from localStorage
    return localStorage.getItem('authToken');
}

/**
 * Remove JWT token from localStorage
 * Used for logout functionality
 */
function removeToken() {
    // Clear token from localStorage
    localStorage.removeItem('authToken');
    // Also clear user data
    localStorage.removeItem('userData');
}

/**
 * Store user data in localStorage
 * @param {Object} user - User object containing id, name, email, role
 */
function saveUserData(user) {
    // Store user data as JSON string
    localStorage.setItem('userData', JSON.stringify(user));
}

/**
 * Get user data from localStorage
 * @returns {Object|null} - User object or null if not found
 */
function getUserData() {
    // Retrieve and parse user data
    const userData = localStorage.getItem('userData');
    return userData ? JSON.parse(userData) : null;
}

/**
 * Check if user is authenticated
 * @returns {boolean} - True if user has valid token
 */
function isAuthenticated() {
    // Check if token exists
    return getToken() !== null;
}

/**
 * Get user role from stored data
 * @returns {string|null} - User role or null if not found
 */
function getUserRole() {
    // Get user data and extract role
    const user = getUserData();
    return user ? user.role : null;
}

/**
 * Make authenticated API request
 * @param {string} endpoint - API endpoint path
 * @param {Object} options - Fetch options (method, body, etc.)
 * @returns {Promise} - Fetch promise
 */
async function authenticatedFetch(endpoint, options = {}) {
    // Get token from storage
    const token = getToken();
    
    // Prepare headers with authentication
    const headers = {
        'Content-Type': 'application/json',
        ...options.headers
    };
    
    // Add Authorization header if token exists
    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }
    
    // Make fetch request with authentication
    const response = await fetch(endpoint, {
        ...options,
        headers
    });
    
    // Handle 401 (Unauthorized) and 403 (Forbidden) globally
    if (response.status === 401 || response.status === 403) {
        // Clear invalid token
        removeToken();
        
        // Show error message
        const message = response.status === 401 
            ? 'Session expired. Please login again.' 
            : 'Access denied. Please login with appropriate permissions.';
        
        alert(message);
        
        // Redirect to login page
        window.location.href = '/login.html';
        
        // Throw error to stop further processing
        throw new Error(message);
    }
    
    return response;
}

/**
 * Redirect to login page if not authenticated
 * Used for protecting routes
 * @param {string} requiredRole - Optional required role for the page
 */
function requireAuth(requiredRole = null) {
    // Check authentication status
    if (!isAuthenticated()) {
        // Redirect to login page
        window.location.href = '/login.html';
        return false;
    }
    
    // Check authorization if role is specified
    if (requiredRole && !hasRole(requiredRole)) {
        // Clear token and redirect to login for unauthorized access
        removeToken();
        alert('Access denied. Please login with appropriate permissions.');
        window.location.href = '/login.html';
        return false;
    }
    
    return true;
}

/**
 * Redirect based on user role
 * Used after successful login
 * @param {string} role - User role
 */
function redirectByRole(role) {
    // Redirect to appropriate dashboard based on role
    // Use absolute paths to avoid path concatenation issues
    switch(role) {
        case 'admin':
            window.location.href = '/dashboard/admin.html';
            break;
        case 'manager':
            window.location.href = '/dashboard/manager.html';
            break;
        case 'analyst':
            window.location.href = '/dashboard/analyst.html';
            break;
        case 'client':
            window.location.href = '/dashboard/client.html';
            break;
        default:
            // Default redirect to home page
            window.location.href = '/index.html';
    }
}

/**
 * Check if user has required role
 * @param {string} requiredRole - Required role for access
 * @returns {boolean} - True if user has required role
 */
function hasRole(requiredRole) {
    // Get current user role
    const userRole = getUserRole();
    
    // Check if user has the required role
    return userRole === requiredRole;
}

/**
 * Show error message in UI
 * @param {string} message - Error message to display
 * @param {string} elementId - ID of element to show message in
 */
function showError(message, elementId = 'errorMessage') {
    // Get error element
    const errorElement = document.getElementById(elementId);
    
    if (errorElement) {
        // Set message and show element
        errorElement.textContent = message;
        errorElement.classList.remove('d-none');
        
        // Hide message after 5 seconds
        setTimeout(() => {
            errorElement.classList.add('d-none');
        }, 5000);
    }
}

/**
 * Show success message in UI
 * @param {string} message - Success message to display
 * @param {string} elementId - ID of element to show message in
 */
function showSuccess(message, elementId = 'successMessage') {
    // Get success element
    const successElement = document.getElementById(elementId);
    
    if (successElement) {
        // Set message and show element
        successElement.textContent = message;
        successElement.classList.remove('d-none');
        
        // Hide message after 3 seconds
        setTimeout(() => {
            successElement.classList.add('d-none');
        }, 3000);
    }
}

/**
 * Handle logout functionality
 * Clears tokens and redirects to login
 */
async function logout() {
    try {
        // Call logout endpoint
        await authenticatedFetch('/api/auth/logout', {
            method: 'POST'
        });
    } catch (error) {
        // Log error but continue with logout
        console.error('Logout error:', error);
    }
    
    // Clear local storage
    removeToken();
    
    // Redirect to login page (use absolute path)
    window.location.href = '/login.html';
} 