/**
 * Generate Self-Signed SSL Certificate for Development
 * This script creates a self-signed certificate for HTTPS development
 */

const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');

// Certificate directory
const certDir = path.join(__dirname, '..', 'certificates');

// Create certificates directory if it doesn't exist
if (!fs.existsSync(certDir)) {
    fs.mkdirSync(certDir, { recursive: true });
    console.log('✅ Created certificates directory');
}

// Certificate configuration
const config = {
    days: 365,
    keySize: 2048,
    country: 'SG',
    state: 'Singapore',
    locality: 'Singapore',
    organization: 'TechSecure',
    organizationalUnit: 'Development',
    commonName: 'localhost',
    email: 'admin@techsecure.local'
};

// OpenSSL configuration file content
const opensslConfig = `
[req]
default_bits = ${config.keySize}
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=${config.country}
ST=${config.state}
L=${config.locality}
O=${config.organization}
OU=${config.organizationalUnit}
CN=${config.commonName}
emailAddress=${config.email}

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = *.localhost
IP.1 = 127.0.0.1
IP.2 = ::1
`;

// Write OpenSSL config
const configPath = path.join(certDir, 'openssl.cnf');
fs.writeFileSync(configPath, opensslConfig);

try {
    console.log('🔐 Generating SSL certificate for development...\n');

    // Check if OpenSSL is available
    try {
        execSync('openssl version', { stdio: 'pipe' });
    } catch (error) {
        console.error('❌ OpenSSL is not installed or not in PATH');
        console.log('\nPlease install OpenSSL:');
        console.log('- Windows: Download from https://slproweb.com/products/Win32OpenSSL.html');
        console.log('- Mac: brew install openssl');
        console.log('- Linux: sudo apt-get install openssl');
        process.exit(1);
    }

    // Generate private key
    console.log('1️⃣ Generating private key...');
    execSync(
        `openssl genrsa -out ${path.join(certDir, 'server.key')} ${config.keySize}`,
        { stdio: 'inherit' }
    );

    // Generate certificate signing request
    console.log('2️⃣ Generating certificate signing request...');
    execSync(
        `openssl req -new -key ${path.join(certDir, 'server.key')} -out ${path.join(certDir, 'server.csr')} -config ${configPath}`,
        { stdio: 'inherit' }
    );

    // Generate self-signed certificate
    console.log('3️⃣ Generating self-signed certificate...');
    execSync(
        `openssl x509 -req -in ${path.join(certDir, 'server.csr')} -signkey ${path.join(certDir, 'server.key')} -out ${path.join(certDir, 'server.crt')} -days ${config.days} -extensions v3_req -extfile ${configPath}`,
        { stdio: 'inherit' }
    );

    // Clean up CSR file
    fs.unlinkSync(path.join(certDir, 'server.csr'));
    fs.unlinkSync(configPath);

    console.log('\n✅ SSL certificate generated successfully!');
    console.log(`📁 Certificate location: ${certDir}`);
    console.log(`📜 Certificate: ${path.join(certDir, 'server.crt')}`);
    console.log(`🔑 Private Key: ${path.join(certDir, 'server.key')}`);
    console.log(`⏰ Valid for: ${config.days} days`);
    console.log('\n⚠️  Note: This is a self-signed certificate for development only.');
    console.log('   Browsers will show a security warning. This is normal for development.');

} catch (error) {
    console.error('❌ Error generating certificate:', error.message);
    process.exit(1);
} 