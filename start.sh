#!/bin/bash

echo "Starting n8n with Docker Compose..."
echo "=================================="
echo ""
echo "Domain: https://${SUBDOMAIN:-n8n}.${DOMAIN_NAME:-demo.test}"
echo "Local access: http://localhost:5678"
echo ""
echo "Make sure you have added the following to your hosts file:"
echo "127.0.0.1 ${SUBDOMAIN:-n8n}.${DOMAIN_NAME:-demo.test}"
echo ""

# Start the services
docker compose up -d

echo ""
echo "Services started! Check status with: docker compose ps"
echo "View logs with: docker compose logs -f"
echo ""
echo "Access n8n at:"
echo "- Local: http://localhost:5678"
echo "- Domain: https://${SUBDOMAIN:-n8n}.${DOMAIN_NAME:-demo.test}"
