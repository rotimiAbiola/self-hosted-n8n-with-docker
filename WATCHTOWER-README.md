# Watchtower Auto-Update Configuration

## Selective Monitoring - n8n Only

Watchtower is configured to **automatically monitor and update only the n8n container**. This ensures your workflows stay up-to-date while keeping critical infrastructure stable.

### What Gets Updated
- **n8n container** - Automatically updated to the latest version  
- **Traefik** - Excluded from auto-updates (stability)  
- **PostgreSQL** - Excluded from auto-updates (data safety)  
- **Watchtower itself** - Excluded from auto-updates

## How Watchtower Works

Watchtower uses **label-based monitoring** to selectively update containers:

1. **Label Check**: Only monitors containers with `com.centurylinklabs.watchtower.enable=true`
2. **Image Check**: Checks for new n8n image versions every 24 hours
3. **Update Process**: Downloads new image → Gracefully stops n8n → Starts with new image
4. **Cleanup**: Removes old images to save disk space
5. **Notifications**: Sends email alerts about updates (if configured)

## Current Configuration

### **Update Schedule**
- **Check Interval**: Every 24 hours (86400 seconds)
- **Auto-cleanup**: Yes (removes old images)
- **Restart Policy**: Only updates running containers
- **Monitoring Mode**: Label-based (selective)

### Monitored Services
- **n8n** - Main application (`watchtower.enable=true`)
- **PostgreSQL** - Excluded from auto-updates (data safety)
- **Traefik** - Excluded from auto-updates (stability)
- **Watchtower** - Excludes itself (safety)

### Safety Features
- **Selective monitoring**: Only n8n gets updated automatically
- **Data preservation**: PostgreSQL and volumes are never touched
- **Infrastructure stability**: Traefik remains on stable version
- **Graceful updates**: Won't start stopped containers
- Can be configured to skip containers with labels

## Email Notifications (Optional)

To enable email notifications, update your `.env` file:

```env
# Update these with your actual email settings
WATCHTOWER_EMAIL_FROM=watchtower@your-domain.com
WATCHTOWER_EMAIL_TO=admin@your-domain.com
WATCHTOWER_EMAIL_SERVER=smtp.gmail.com
WATCHTOWER_EMAIL_PORT=587
WATCHTOWER_EMAIL_USER=your-email@gmail.com
WATCHTOWER_EMAIL_PASSWORD=your-app-password
```

**For Gmail:**
1. Enable 2FA on your Google account
2. Generate an App Password
3. Use the App Password instead of your regular password

## Starting Watchtower

```bash
# Start Watchtower
docker compose up watchtower -d

# Check Watchtower logs
docker compose logs watchtower -f

# Check all services
docker compose ps
```

## Excluding Containers

To prevent specific containers from being updated, add this label:
```yaml
labels:
  - "com.centurylinklabs.watchtower.enable=false"
```

## Custom Update Schedule

You can change the update frequency by modifying `WATCHTOWER_POLL_INTERVAL`:
- **Daily**: 86400 (current setting)
- **Weekly**: 604800
- **Hourly**: 3600

## 🔧 Advanced Options

### Monitor Only Specific Containers
```yaml
environment:
  - WATCHTOWER_MONITOR_ONLY=true
command: ["n8n", "postgres"]  # Only monitor these containers
```

### Update Immediately on Detection
```yaml
environment:
  - WATCHTOWER_POLL_INTERVAL=30  # Check every 30 seconds
```

### Dry Run Mode (Testing)
```yaml
environment:
  - WATCHTOWER_DRY_RUN=true  # Only log what would be updated
```

## Monitoring Updates

```bash
# View Watchtower logs
docker compose logs watchtower --tail 50

# Check container versions
docker images | grep -E "(n8n|postgres|traefik)"

# Manual update check
docker compose exec watchtower watchtower --run-once
```

## Important Notes

1. **Database Safety**: PostgreSQL updates are generally safe, but major version upgrades may require manual intervention
2. **n8n Updates**: Your workflows and data persist across updates
3. **Traefik Updates**: SSL certificates and routing rules are preserved
4. **Rollback**: If an update causes issues, you can rollback by specifying the previous image tag

## Manual Rollback

If you need to rollback to a previous version:
```bash
# Stop the service
docker compose stop n8n

# Update compose.yaml to specify version
# image: docker.n8n.io/n8nio/n8n:1.104.2

# Restart with specific version
docker compose up n8n -d
```

## Benefits

- **Security**: Always get the latest security patches
- **Features**: Automatic access to new features
- **Maintenance**: Reduces manual update overhead
- **Reliability**: Consistent update process
- **Notifications**: Stay informed about updates
