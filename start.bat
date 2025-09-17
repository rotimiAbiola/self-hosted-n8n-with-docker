@echo off
echo Starting n8n with Docker Compose...
echo ==================================
echo.

REM Read environment variables
for /f "tokens=1,2 delims==" %%i in ('type .env ^| findstr /v "^#"') do (
    if "%%i"=="SUBDOMAIN" set SUBDOMAIN=%%j
    if "%%i"=="DOMAIN_NAME" set DOMAIN_NAME=%%j
)

echo Domain: https://%SUBDOMAIN%.%DOMAIN_NAME%
echo Local access: http://localhost:5678
echo.
echo Make sure you have added the following to your hosts file:
echo 127.0.0.1 %SUBDOMAIN%.%DOMAIN_NAME%
echo.

REM Start the services
docker compose up -d

echo.
echo Services started! Check status with: docker compose ps
echo View logs with: docker compose logs -f
echo.
echo Access n8n at:
echo - Local: http://localhost:5678
echo - Domain: https://%SUBDOMAIN%.%DOMAIN_NAME%
