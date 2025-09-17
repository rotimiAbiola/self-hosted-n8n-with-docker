# Security & Sensitive Files Guide

## Files Excluded from Git (.gitignore)

The following files contain sensitive information and are **NOT** included in this repository:

### Credentials & Secrets
- `.env` - Environment variables with passwords and API keys
- `client_secret_*.json` - Google OAuth credentials
- `cloudflared/` - Cloudflare tunnel credentials and certificates

### SSL Certificates
- `certs/` - SSL private keys and certificates
- `*.pem`, `*.key`, `*.crt` - Any certificate files

### Data & Backups
- `local-files/` - n8n workflow and credential backups
- `*.db`, `*.sqlite` - Database files

### System Files
- `*.exe` - Executable files (like mkcert.exe)
- `*.zip` - Compressed archives
- OS-specific files (.DS_Store, Thumbs.db, etc.)

## Setup Checklist After Cloning

### Required Steps:

1. **Copy environment template:**
   ```bash
   cp .env.template .env
   ```

2. **Edit .env with your values:**
   - Change `DOMAIN_NAME` to your domain
   - Set a secure `POSTGRES_PASSWORD`
   - Configure email settings for notifications (optional)

3. **Generate SSL certificates:**
   ```bash
   # Install mkcert first, then:
   mkdir certs
   mkcert -key-file certs/key.pem -cert-file certs/cert.pem "*.yourdomain.com" yourdomain.com localhost
   ```

4. **Update hosts file:**
   Add your domain to point to localhost

5. **Start services:**
   ```bash
   docker compose up -d
   ```

### Security Best Practices:

- **Never commit the real .env file**
- **Generate unique, strong passwords**
- **Keep certificates private and secure**
- **Regularly rotate credentials**
- **Monitor for security updates**

### Optional: Email Notifications

To enable Watchtower email notifications:

1. Create Gmail App Password (not your regular password)
2. Update `.env` with email settings
3. Restart Watchtower service

### Production Considerations:

- Use proper DNS for your domain
- Consider Let's Encrypt for production SSL
- Implement proper backup strategies
- Set up monitoring and alerting
- Use secrets management solutions

## What NOT to Do:

- ❌ Don't commit real credentials to git
- ❌ Don't share .env files publicly  
- ❌ Don't use weak passwords
- ❌ Don't ignore security updates
- ❌ Don't expose services without proper authentication

## Need Help?

Check `SETUP.md` for detailed setup instructions and troubleshooting guides.
