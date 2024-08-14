#!/bin/bash

# Generate a random WORKER_ID
WORKER_ID=$(openssl rand -hex 8)
export WORKER_ID

# Start the Celery worker
celery -A worker.celery_app worker --loglevel=info
