import uuid
import datetime
import os
from flask import Flask, render_template, request, jsonify
from celery.result import AsyncResult
from celery_app import celery_app  # Import your Celery instance
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB Setup with Authentication using environment variables
mongo_username = os.getenv('MONGO_USERNAME')
mongo_password = os.getenv('MONGO_PASSWORD')
mongo_address = os.getenv('MONGO_ADDRESS')
mongo_db = os.getenv('MONGO_DB')

client = MongoClient(f'mongodb://{mongo_username}:{mongo_password}@{mongo_address}/{mongo_db}?authSource=admin')
db = client.task_db

@app.route('/')
def index():
    # Fetch worker status
    i = celery_app.control.inspect()
    worker_status = i.ping() or {}
    worker_count = len(worker_status)
    return render_template('index.html', worker_count=worker_count, worker_status=worker_status)

@app.route('/submit', methods=['POST'])
def submit_task():
    if request.is_json:
        data = request.get_json()
        command = data.get('command')
    else:
        command = request.form.get['command']

    if not command:
        return "Command is required", 400
    task_id = str(uuid.uuid4())

    # Broadcast the task to all workers
    #celery_app.control.broadcast('worker.execute_task', arguments=[command])

    celery_app.send_task('worker.execute_task', arguments=[task_id, command])

    # Store the task details in the database
    db.tasks.insert_one({
        'task_id': task_id,
        'command': command,
        'status': 'Queue',
        'submitted_at': datetime.datetime.utcnow()
    })
    return jsonify({'task_id': task_id, 'status': 'submitted'})

@app.route('/tasks')
def list_tasks():
    tasks = list(db.tasks.find({}, {'_id': 0}))  # Exclude the MongoDB internal ID
    return jsonify(tasks)

@app.route('/all-tasks')
def list_all_tasks():
    all_tasks = list(db.tasks.find({}, {'_id': 0}))  # Fetch tasks and exclude MongoDB internal ID
    return render_template('tasks.html', tasks=all_tasks)

@app.route('/status/<task_id>')
def get_task_status(task_id):
    task = AsyncResult(task_id, app=celery_app)
    status = task.state
    result = task.result if task.state == 'SUCCESS' else None
    error = str(task.result) if task.state == 'FAILURE' else None
    # Update status in the database
    db.tasks.update_one(
        {'task_id': task_id},
        {'$set': {'status': status, 'result': result, 'error': error}}
    )
    return jsonify({'task_id': task_id, 'status': status, 'result': result, 'error': error})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
