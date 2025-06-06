FROM python:3.9-slim


RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt --verbose

COPY . /app
EXPOSE 8501

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=127.0.0.1"]