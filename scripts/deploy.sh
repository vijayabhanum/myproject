#!/bin/bash

set -e

echo "======================="
echo "Starting Deployment"
echo "======================="
echo ""

echo " pulling latest code form Git..."
git pull origin main

echo ""
echo "Building Docker Images..."
docker compose -f docker-compose.prod.yml build --no-cache

echo ""
echo "Stopping old containers"
docker compose -f docker-compose.prod.yml down

echo ""
echo "Starting new containers..."
docker compose -f docker-compose.prod.yml up -d

#waiting for servers to be ready
echo ""
echo "Waiting for services to be start."
sleep 10

echo ""
echo "Running database migrations..."
docker compose -f docker-compose.prod.yml exec -T web python manage.py migrate --noinput

echo ""
echo "Collecting static files..."
docker compose -f docker-compose.prod.yml exec -T web python manage.py collectstatic --noinput --clear

echo ""
echo "Container Status:"
docker compose -f docker-compose.prod.yml ps

echo ""
echo "======================="
echo "Deployment complete"
echo "======================="

