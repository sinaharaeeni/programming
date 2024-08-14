import os
from celery import Celery

# MongoDB Setup with Authentication using environment variables
mongo_username = os.getenv('MONGO_USERNAME')
mongo_password = os.getenv('MONGO_PASSWORD')
mongo_address = os.getenv('MONGO_ADDRESS')
mongo_db = os.getenv('MONGO_DB')
database = (f'mongodb://{mongo_username}:{mongo_password}@{mongo_address}/{mongo_db}?authSource=admin')

celery_app = Celery('tasks', broker='redis://redis:6379/0', backend=database)
