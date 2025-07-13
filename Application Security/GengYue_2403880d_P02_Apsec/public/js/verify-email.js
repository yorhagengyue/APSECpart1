// Get URL parameters
const urlParams = new URLSearchParams(window.location.search);
const token = urlParams.get('token');
const email = urlParams.get('email');

// Elements
const verificationStatus = document.getElementById('verificationStatus');
const verificationSuccess = document.getElementById('verificationSuccess');
const verificationError = document.getElementById('verificationError');
const errorMessage = document.getElementById('errorMessage');
const resendBtn = document.getElementById('resendBtn');
const resendEmail = document.getElementById('resendEmail');
const resendMessage = document.getElementById('resendMessage');

// Verify email on page load
window.addEventListener('DOMContentLoaded', async () => {
    if (!token || !email) {
        showError('Invalid verification link. Missing token or email.');
        return;
    }

    try {
        const response = await fetch('/api/auth/verify-email', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ token, email })
        });

        const data = await response.json();

        if (response.ok) {
            showSuccess();
        } else {
            showError(data.error || 'Verification failed');
        }
    } catch (error) {
        showError('Network error. Please try again later.');
    }
});

// Resend verification email
resendBtn.addEventListener('click', async () => {
    const emailToResend = resendEmail.value || email;
    
    if (!emailToResend) {
        showResendMessage('Please enter your email address', 'danger');
        return;
    }

    // Disable button and show loading
    resendBtn.disabled = true;
    resendBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Sending...';
    resendMessage.innerHTML = '';

    try {
        const response = await fetch('/api/auth/resend-verification', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email: emailToResend })
        });

        const data = await response.json();

        if (response.ok) {
            showResendMessage('Verification email sent! Please check your inbox.', 'success');
            resendEmail.value = '';
        } else {
            showResendMessage(data.error || 'Failed to send email', 'danger');
        }
    } catch (error) {
        showResendMessage('Network error. Please try again later.', 'danger');
    } finally {
        // Re-enable button
        resendBtn.disabled = false;
        resendBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Resend';
    }
});

// Helper functions
function showSuccess() {
    verificationStatus.style.display = 'none';
    verificationError.style.display = 'none';
    verificationSuccess.style.display = 'block';
}

function showError(message) {
    verificationStatus.style.display = 'none';
    verificationSuccess.style.display = 'none';
    verificationError.style.display = 'block';
    errorMessage.textContent = message;
    
    // Pre-fill email if available
    if (email) {
        resendEmail.value = email;
    }
}

function showResendMessage(message, type) {
    resendMessage.innerHTML = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
} 