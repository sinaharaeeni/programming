# @celery_app.task(name='worker.execute_task')
# def execute_task(task_id, command):
#     logging.info(f"Received command: {command}")
#     try:
#         result = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
#         logging.info(f"Command output: {result.decode()}")
#         return result.decode()
#     except subprocess.CalledProcessError as e:
#         logging.error(f"Command error: {e.output.decode()}")
#         return f"Error: {e.output.decode()}"

import datetime
import os
import uuid
import subprocess
import logging
from celery import Celery
from pymongo import MongoClient

logging.basicConfig(level=logging.INFO)

celery_app = Celery('tasks', broker='redis://redis:6379/0')

# MongoDB Setup with Authentication using environment variables
mongo_username = os.getenv('MONGO_USERNAME')
mongo_password = os.getenv('MONGO_PASSWORD')
mongo_address = os.getenv('MONGO_ADDRESS')
mongo_db = os.getenv('MONGO_DB')

client = MongoClient(f'mongodb://{mongo_username}:{mongo_password}@{mongo_address}/{mongo_db}?authSource=admin')
db = client.task_db

@celery_app.task(name="worker.execute_task")
def execute_task(task_id, command):
    # Insert the initial task record into the database
    db.tasks.insert_one({
        'task_id': task_id,
        'command': command,
        'status': 'Wating',
        'result': None,
        'error': None,
        'worker_id': None,
        'started_at': None,
        'completed_at': None
    })

    try:
        # Execute the command and capture the output
        started_at = datetime.datetime.utcnow()
        result = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        status = 'Success'
        error = None
    except subprocess.CalledProcessError as e:
        result = e.output
        status = 'Failure'
        error = str(e)

    # Update the task document in the database with the result
    db.tasks.update_one(
        {'task_id': task_id},
        {'$set': {
            'status': status,
            'result': result,
            'error': error,
            'worker_id': os.getenv('WORKER_ID', 'unknown'),
            'started_at': started_at,
            'completed_at': datetime.datetime.utcnow()
        }}
    )

    return result
