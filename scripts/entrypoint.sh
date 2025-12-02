#!/bin/bash

set -e

echo ""
echo "======================================"
echo "Djano container starting..."
echo ""

echo "Fixing permissions for mounted volumes.."
mkdir -p /app/staticfiles /app/media /app/logs
chown -R appuser:appuser /app/staticfiles /app/media /app/logs
chmod -R 755 /app/staticfiles /app/media /app/logs
echo "Permissions fixed!"


echo "Waiting for PostgreSQL..."
while ! nc -z $DB_HOST $DB_PORT; do
    sleep 0.1
done

echo "Postgresql is ready!!"

echo ""
echo "RUnning database migrations..."
python manage.py migrate --noinput
echo " Migrations completed!!"

echo ""
echo "Collecting static files.."
python manage.py collectstatic --noinput --clear
echo "Static files collected!"

echo ""
echo "Ensuring final permissions..."
chown -R appuser:appuser /app/logs
echo "✓ Final permissions set!"


echo ""
echo "=========================================="
echo "Starting Gunicorn server..."
echo "=========================================="
echo ""

exec su appuser -c "gunicorn myproject.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers ${GUNICORN_WORKERS:-3} \
    --threads ${GUNICORN_THREADS:-2} \
    --worker-class gthread \
    --worker-tmp-dir /dev/shm \
    --max-requests 1000 \
    --max-requests-jitter 50 \
    --access-logfile /app/logs/gunicorn-access.log \
    --error-logfile /app/logs/gunicorn-error.log \
    --log-level info \
    --timeout ${GUNICORN_TIMEOUT:-120} \
    --graceful-timeout 30 \
    --keep-alive 5"