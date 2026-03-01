FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies needed by curl_cffi (libcurl)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (layer caching — only rebuilds if requirements change)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all scripts and data files
COPY . .

# Railway injects PORT — our health check server reads it automatically
EXPOSE 8080

# Default command — override in railway.json per service
CMD ["python", "-u", "nproduct.py"]
