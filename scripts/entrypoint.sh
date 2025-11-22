#!/bin/bash

set -e

echo "Waiting for Postgresql to be ready..."

while ! nc -z $DB_HOST $DB_PORT; do
  sleep 0.1
done

echo "Postgresql started succesfully!"

until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
  echo "postgresql is unavailable -retrying...."
  sleep 1
done

echo "PostgresQL is ready for connections!"

echo "running database migrations.."

python manage.py migrate --noinput

python manage.py showmigrations

echo "collecting statis files .."

python manage.py collectstatic --noinput --clear

echo "starting gunicorn..."

exec gunicorn myproject.wsgi:application \
  --bind 0.0.0.0:8000 \
  --workers 3 \
  --worker-class gthread

echo "Gunicorn started succesfully !"
echo "application is ready to accept requests."

