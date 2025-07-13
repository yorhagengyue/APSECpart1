/**
 * Email Verification Reminder Component
 * Shows a reminder banner for users who haven't verified their email
 */

// Check if user is logged in and email is not verified
function checkEmailVerificationStatus() {
    const userData = getUserData();
    
    if (userData && userData.isEmailVerified === false) {
        showEmailVerificationReminder(userData.email);
    }
}

// Show email verification reminder banner
function showEmailVerificationReminder(email) {
    // Check if reminder was already dismissed this session
    if (sessionStorage.getItem('emailReminderDismissed') === 'true') {
        return;
    }
    
    // Create reminder element
    const reminder = document.createElement('div');
    reminder.id = 'emailVerificationReminder';
    reminder.className = 'alert alert-warning alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
    reminder.style.zIndex = '9999';
    reminder.style.maxWidth = '600px';
    reminder.innerHTML = `
        <i class="fas fa-exclamation-triangle"></i>
        <strong>Email Not Verified</strong>
        <p class="mb-2 mt-1">Your email address hasn't been verified yet. Verify it to ensure you can recover your account if needed.</p>
        <button type="button" class="btn btn-sm btn-warning" onclick="resendVerificationReminder('${email}')">
            <i class="fas fa-paper-plane"></i> Resend Verification Email
        </button>
        <button type="button" class="btn-close" onclick="dismissEmailReminder()"></button>
    `;
    
    // Add to page
    document.body.appendChild(reminder);
}

// Resend verification email from reminder
async function resendVerificationReminder(email) {
    try {
        const btn = event.target;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Sending...';
        
        const response = await fetch('/api/auth/resend-verification', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email })
        });
        
        const data = await response.json();
        
        if (response.ok) {
            // Update reminder to show success
            const reminder = document.getElementById('emailVerificationReminder');
            reminder.className = 'alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
            reminder.innerHTML = `
                <i class="fas fa-check-circle"></i>
                <strong>Email Sent!</strong>
                <p class="mb-0 mt-1">Verification email has been sent to ${email}. Please check your inbox.</p>
                <button type="button" class="btn-close" onclick="dismissEmailReminder()"></button>
            `;
            
            // Auto-dismiss after 5 seconds
            setTimeout(() => {
                dismissEmailReminder();
            }, 5000);
        } else {
            alert(data.error || 'Failed to send verification email');
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-paper-plane"></i> Resend Verification Email';
        }
    } catch (error) {
        alert('Network error. Please try again later.');
        const btn = event.target;
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-paper-plane"></i> Resend Verification Email';
    }
}

// Dismiss email reminder
function dismissEmailReminder() {
    const reminder = document.getElementById('emailVerificationReminder');
    if (reminder) {
        reminder.remove();
        // Remember dismissal for this session
        sessionStorage.setItem('emailReminderDismissed', 'true');
    }
}

// Make functions available globally
window.resendVerificationReminder = resendVerificationReminder;
window.dismissEmailReminder = dismissEmailReminder;

// Auto-check on page load
document.addEventListener('DOMContentLoaded', function() {
    // Only show on dashboard pages
    if (window.location.pathname.includes('/dashboard/')) {
        setTimeout(() => {
            checkEmailVerificationStatus();
        }, 1000); // Delay to avoid interfering with page load
    }
}); 