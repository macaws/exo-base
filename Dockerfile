FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    clang \
    git \
    gcc \
    g++ \
    make \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies in groups to isolate potential failures
RUN pip install --no-cache-dir \
    setuptools \
    wheel \
    numpy

# Install packages that need compilation
RUN pip install --no-cache-dir \
    netifaces==0.11.0 \
    grpcio==1.68.0 \
    grpcio-tools==1.68.0

# Install remaining dependencies
RUN pip install --no-cache-dir \
    opencv-python-headless \
    tinygrad \
    aiohttp==3.10.11 \
    aiohttp_cors==0.7.0 \
    aiofiles==24.1.0 \
    Jinja2==3.1.4 \
    prometheus-client==0.20.0 \
    psutil==6.0.0 \
    pydantic==2.9.2 \
    requests==2.32.3 \
    rich==13.7.1 \
    tenacity==9.0.0 \
    tqdm==4.66.4 \
    transformers==4.46.3 \
    torch

# Create non-root user
RUN groupadd -r appuser -g 568 && \
    useradd -r -g appuser -u 568 -m appuser

# Create required directories
RUN mkdir -p /config/.local/bin /config/.cache && \
    chown -R appuser:appuser /config

# Switch to non-root user
USER appuser

# Set working directory
WORKDIR /app

# Set environment variables
ENV HOME=/config \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/config \
    PYTHONPATH=/config/.local/lib/python3.12/site-packages:/app \
    PATH=/config/.local/bin:$PATH \
    PYTHONUNBUFFERED=1

# Default command
CMD ["python3"]