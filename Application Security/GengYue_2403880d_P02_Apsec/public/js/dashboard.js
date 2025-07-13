/**
 * dashboard.js - Common dashboard functionality
 * Shared functions for all dashboard pages
 */

// Check authentication on page load
document.addEventListener('DOMContentLoaded', function() {
    // Verify user is authenticated
    if (!requireAuth()) {
        return; // requireAuth will redirect if not authenticated
    }
    
    // Update user info in UI
    updateUserInfo();
    
    // Load common dashboard data
    loadCommonData();
});

/**
 * Update user information in the UI
 */
function updateUserInfo() {
    // Get user data from storage
    const userData = getUserData();
    
    if (userData) {
        // Update all elements with user name
        const userNameElements = document.querySelectorAll('#userName, .user-name');
        userNameElements.forEach(element => {
            element.textContent = userData.name;
        });
        
        // Update all elements with user email
        const userEmailElements = document.querySelectorAll('#userEmail, .user-email');
        userEmailElements.forEach(element => {
            element.textContent = userData.email;
        });
        
        // Update all elements with user role
        const userRoleElements = document.querySelectorAll('#userRole, .user-role');
        userRoleElements.forEach(element => {
            element.textContent = userData.role;
        });
    }
}

/**
 * Load common dashboard data
 */
async function loadCommonData() {
    try {
        // Get current user info from API
        const response = await authenticatedFetch('/api/auth/me');
        const data = await response.json();
        
        if (response.ok && data.success) {
            // Update stored user data with latest from server
            saveUserData(data.data);
            
            // Update UI with fresh data
            updateUserInfo();
        }
    } catch (error) {
        console.error('Error loading user data:', error);
    }
}

/**
 * Format date for display
 * @param {string} dateString - ISO date string
 * @returns {string} - Formatted date
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

/**
 * Format time for display
 * @param {string} dateString - ISO date string
 * @returns {string} - Formatted time
 */
function formatTime(dateString) {
    const date = new Date(dateString);
    return date.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * Show loading spinner
 * @param {string} elementId - ID of element to show spinner in
 */
function showLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = `
            <div class="text-center p-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        `;
    }
}

/**
 * Hide loading spinner
 * @param {string} elementId - ID of element to hide spinner from
 */
function hideLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = '';
    }
}

/**
 * Create a notification toast
 * @param {string} message - Notification message
 * @param {string} type - Notification type (success, error, info, warning)
 */
function showNotification(message, type = 'info') {
    // Create toast container if it doesn't exist
    let toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1050';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toastId = 'toast-' + Date.now();
    const toastHtml = `
        <div id="${toastId}" class="toast align-items-center text-white bg-${type === 'error' ? 'danger' : type} border-0" role="alert">
            <div class="d-flex">
                <div class="toast-body">
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;
    
    // Add toast to container
    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    
    // Initialize and show toast
    const toastElement = document.getElementById(toastId);
    const toast = new bootstrap.Toast(toastElement, {
        autohide: true,
        delay: 5000
    });
    toast.show();
    
    // Remove toast element after it's hidden
    toastElement.addEventListener('hidden.bs.toast', function() {
        toastElement.remove();
    });
}

/**
 * Confirm action with modal
 * @param {string} title - Modal title
 * @param {string} message - Confirmation message
 * @param {Function} onConfirm - Callback function when confirmed
 */
function confirmAction(title, message, onConfirm) {
    // Create modal HTML
    const modalHtml = `
        <div class="modal fade" id="confirmModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">${title}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>${message}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="confirmBtn">Confirm</button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Add modal to body
    document.body.insertAdjacentHTML('beforeend', modalHtml);
    
    // Get modal elements
    const modalElement = document.getElementById('confirmModal');
    const confirmBtn = document.getElementById('confirmBtn');
    
    // Initialize modal
    const modal = new bootstrap.Modal(modalElement);
    
    // Handle confirm button click
    confirmBtn.addEventListener('click', function() {
        onConfirm();
        modal.hide();
    });
    
    // Remove modal after hidden
    modalElement.addEventListener('hidden.bs.modal', function() {
        modalElement.remove();
    });
    
    // Show modal
    modal.show();
}

/**
 * Handle session timeout
 */
function handleSessionTimeout() {
    // Show notification
    showNotification('Your session has expired. Please login again.', 'warning');
    
    // Clear auth data
    removeToken();
    
    // Redirect to login after delay
    setTimeout(() => {
        window.location.href = '../login.html';
    }, 2000);
}

// Add global error handler for 401 responses
window.addEventListener('unhandledrejection', function(event) {
    if (event.reason && event.reason.status === 401) {
        handleSessionTimeout();
    }
}); 