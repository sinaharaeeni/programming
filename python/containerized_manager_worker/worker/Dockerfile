FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

# Add a script to generate a random WORKER_ID
COPY start_worker.sh /start_worker.sh
RUN chmod +x /start_worker.sh

CMD ["/start_worker.sh"]
