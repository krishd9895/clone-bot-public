# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /usr/src/app

# Install system dependencies and libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    python3-dev \
    build-essential

# Create a virtual environment
RUN python3 -m venv /usr/src/app/venv

# Install pip in the virtual environment
RUN /bin/bash -c "source /usr/src/app/venv/bin/activate && pip install --upgrade pip"

# Copy the requirements file
COPY requirements.txt .

# Activate the virtual environment and install Python packages
RUN /bin/bash -c "source /usr/src/app/venv/bin/activate && pip install --no-cache-dir -r requirements.txt"

# Install Playwright dependencies
RUN /bin/bash -c "source /usr/src/app/venv/bin/activate && playwright install-deps && playwright install"

# Copy the rest of the application code
COPY . .

# Set entrypoint to activate the virtual environment and run the application
ENTRYPOINT ["/bin/bash", "-c", "source /usr/src/app/venv/bin/activate && exec \"$@\"", "--"]

# Default command to run when container starts
CMD ["bash", "-c", "python3 load.py && python3 -m bot"]
