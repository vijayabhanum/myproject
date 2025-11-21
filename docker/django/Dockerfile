FROM python:3.11-slim as base

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

ENV PYTHONHASHSEED=random

WORKDIR /app

RUN apt-get update && apt-get install -y \
    postgresql-client \
    gcc \
    g++ \
    python3-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    curl \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

RUN mkdir -p /app/static /app/media /app/logs

RUN chown -R appuser:appuser /app

USER appuser

COPY --chown=appuser:appuser scripts/entrypoint.sh /app/

RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]

