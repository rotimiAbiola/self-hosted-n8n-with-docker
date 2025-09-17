# Setup Guide for n8n Docker Environment

## Initial Setup

### 1. Clone and Configure

```bash
git clone <your-repo-url>
cd n8n-docker
cp .env.template .env
```

### 2. Edit Environment Variables

Edit `.env` file with your settings:

```bash
# Your domain settings
DOMAIN_NAME=yourdomain.com
SUBDOMAIN=n8n

# Database password (make it secure!)
POSTGRES_PASSWORD=your_very_secure_password_here

# Optional: Email notifications for auto-updates
WATCHTOWER_EMAIL_FROM=watchtower@yourdomain.com
WATCHTOWER_EMAIL_TO=admin@yourdomain.com
WATCHTOWER_EMAIL_USER=your-email@gmail.com
WATCHTOWER_EMAIL_PASSWORD=your-gmail-app-password
```

### 3. SSL Certificates (Recommended)

For local development with trusted certificates:

**Install mkcert:**
```bash
# Windows (using chocolatey)
choco install mkcert

# macOS
brew install mkcert

# Linux
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x mkcert-v*-linux-amd64
sudo cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert
```

**Generate certificates:**
```bash
mkcert -install
mkdir -p certs
mkcert -key-file certs/key.pem -cert-file certs/cert.pem "*.yourdomain.com" yourdomain.com localhost 127.0.0.1 ::1
```

### 4. Update Hosts File

Add your domain to `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):

```
127.0.0.1 n8n.yourdomain.com
```

## Starting Services

### Method 1: All Services
```bash
docker compose up -d
```

### Method 2: Staged Startup
```bash
# Start infrastructure first
docker compose up traefik postgres -d

# Wait for database to be ready, then start n8n
docker compose up n8n -d

# Finally start auto-updater
docker compose up watchtower -d
```

## Monitoring

### Check Service Status
```bash
docker compose ps
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f n8n
docker compose logs -f watchtower
```

### Health Checks
```bash
# Check database health
docker compose exec postgres pg_isready -U postgres

# Check n8n connectivity
curl -k https://n8n.yourdomain.com/healthz
```

## Data Migration

If you have existing n8n data in SQLite:

1. **Export from SQLite n8n:**
   - Settings → Import/Export → Export all data

2. **Import to new PostgreSQL n8n:**
   - Settings → Import/Export → Import data

3. **Verify migration:**
   - Check all workflows are present
   - Test credential connections
   - Verify executions work correctly

## Security Notes

### Files to NEVER commit:
- `.env` - Contains passwords and secrets
- `certs/` - SSL private keys
- `cloudflared/` - Tunnel credentials  
- `local-files/` - n8n backups with credentials
- `client_secret_*.json` - OAuth credentials

### Recommended Security:
- Use strong, unique database passwords
- Regularly rotate credentials
- Monitor Watchtower email notifications
- Keep certificates secure and backed up privately

## Troubleshooting

### SSL Certificate Issues
```bash
# Regenerate certificates
rm -rf certs/
mkcert -key-file certs/key.pem -cert-file certs/cert.pem "*.yourdomain.com" yourdomain.com localhost
```

### Database Connection Issues
```bash
# Reset database
docker compose down
docker volume rm n8n_postgres_storage
docker compose up postgres -d
```

### Watchtower Not Updating
```bash
# Check labels
docker inspect n8n-n8n-1 | grep -A5 -B5 watchtower

# Force update check
docker compose exec watchtower watchtower --run-once
```

## Email Notifications

To enable Watchtower email notifications:

1. **Enable 2FA** on your Gmail account
2. **Generate App Password** in Google Account settings
3. **Update .env** with your app password (not your regular password)
4. **Restart Watchtower** to apply new settings

## Production Deployment

For production deployment:

1. **Use real domain** with proper DNS
2. **Use production SSL certificates** (Let's Encrypt via Traefik)
3. **Secure database** with network isolation
4. **Monitor logs** and set up proper alerting
5. **Backup strategies** for PostgreSQL data
6. **Regular security updates** beyond just n8n
