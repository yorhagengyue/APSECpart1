// Simple password policy for frontend
function validatePasswordPolicy(password, userInfo = {}) {
    const errors = [];
    
    if (password.length < 8) errors.push('Password must be at least 8 characters long');
    if (!/[A-Z]/.test(password)) errors.push('Must contain uppercase letter');
    if (!/[a-z]/.test(password)) errors.push('Must contain lowercase letter');
    if (!/\d/.test(password)) errors.push('Must contain number');
    if (!/[!@#$%^&*]/.test(password)) errors.push('Must contain special character');
    
    const commonPasswords = ['password', '123456', 'qwerty', 'admin'];
    if (commonPasswords.includes(password.toLowerCase())) {
        errors.push('Password too common');
    }

    return { isValid: errors.length === 0, errors };
}

function calculatePasswordStrength(password) {
    let score = password.length * 4;
    if (/[a-z]/.test(password)) score += 5;
    if (/[A-Z]/.test(password)) score += 5;
    if (/\d/.test(password)) score += 5;
    if (/[!@#$%^&*]/.test(password)) score += 10;
    return Math.min(100, score);
}

function displayPasswordStrength(password, containerId) {
    const container = document.getElementById(containerId);
    if (!container || !password) {
        if (container) container.innerHTML = '';
        return;
    }

    const validation = validatePasswordPolicy(password);
    const strength = calculatePasswordStrength(password);
    const color = strength < 50 ? 'danger' : strength < 80 ? 'warning' : 'success';

    container.innerHTML = `
        <div class="mt-2">
            <div class="progress mb-1" style="height: 6px;">
                <div class="progress-bar bg-${color}" style="width: ${strength}%"></div>
            </div>
            ${validation.errors.length > 0 ? 
                validation.errors.map(error => `<small class="text-danger d-block">${error}</small>`).join('') 
                : '<small class="text-success">Password meets requirements</small>'
            }
        </div>
    `;
} 