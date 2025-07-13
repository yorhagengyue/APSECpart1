/**
 * Generate Self-Signed SSL Certificate using Node.js
 * No external dependencies like OpenSSL required
 */

const forge = require('node-forge');
const fs = require('fs');
const path = require('path');

// Certificate directory
const certDir = path.join(__dirname, '..', 'certificates');

// Create certificates directory if it doesn't exist
if (!fs.existsSync(certDir)) {
    fs.mkdirSync(certDir, { recursive: true });
}

console.log('🔐 Generating SSL certificate for development...\n');

// Generate a keypair
console.log('1️⃣ Generating RSA key pair...');
const keys = forge.pki.rsa.generateKeyPair(2048);

// Create a certificate
console.log('2️⃣ Creating certificate...');
const cert = forge.pki.createCertificate();

// Set certificate fields
cert.publicKey = keys.publicKey;
cert.serialNumber = '01';
cert.validity.notBefore = new Date();
cert.validity.notAfter = new Date();
cert.validity.notAfter.setFullYear(cert.validity.notBefore.getFullYear() + 1);

// Certificate attributes
const attrs = [{
    name: 'commonName',
    value: 'localhost'
}, {
    name: 'countryName',
    value: 'SG'
}, {
    shortName: 'ST',
    value: 'Singapore'
}, {
    name: 'localityName',
    value: 'Singapore'
}, {
    name: 'organizationName',
    value: 'TechSecure'
}, {
    shortName: 'OU',
    value: 'Development'
}];

cert.setSubject(attrs);
cert.setIssuer(attrs);

// Add extensions
cert.setExtensions([{
    name: 'basicConstraints',
    cA: true
}, {
    name: 'keyUsage',
    keyCertSign: true,
    digitalSignature: true,
    nonRepudiation: true,
    keyEncipherment: true,
    dataEncipherment: true
}, {
    name: 'extKeyUsage',
    serverAuth: true,
    clientAuth: true,
    codeSigning: true,
    emailProtection: true,
    timeStamping: true
}, {
    name: 'nsCertType',
    client: true,
    server: true,
    email: true,
    objsign: true,
    sslCA: true,
    emailCA: true,
    objCA: true
}, {
    name: 'subjectAltName',
    altNames: [{
        type: 2, // DNS
        value: 'localhost'
    }, {
        type: 2, // DNS
        value: '*.localhost'
    }, {
        type: 7, // IP
        ip: '127.0.0.1'
    }, {
        type: 7, // IP
        ip: '::1'
    }]
}, {
    name: 'subjectKeyIdentifier'
}]);

// Sign the certificate
console.log('3️⃣ Signing certificate...');
cert.sign(keys.privateKey, forge.md.sha256.create());

// Convert to PEM format
const pemCert = forge.pki.certificateToPem(cert);
const pemKey = forge.pki.privateKeyToPem(keys.privateKey);

// Save files
const certPath = path.join(certDir, 'server.crt');
const keyPath = path.join(certDir, 'server.key');

fs.writeFileSync(certPath, pemCert);
fs.writeFileSync(keyPath, pemKey);

console.log('\n✅ SSL certificate generated successfully!');
console.log(`📁 Certificate location: ${certDir}`);
console.log(`📜 Certificate: ${certPath}`);
console.log(`🔑 Private Key: ${keyPath}`);
console.log(`⏰ Valid for: 1 year`);
console.log('\n⚠️  Note: This is a self-signed certificate for development only.');
console.log('   Browsers will show a security warning. This is normal for development.');
console.log('\n💡 To use HTTPS, start the server with: npm run start:https'); 