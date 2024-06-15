# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy application code and requirements file
COPY ./app /app

# Install dependencies
RUN pip install --no-cache-dir -r pip-packages.txt

# Create a new user and group
RUN groupadd -r msinsa -g 1000 && useradd -r -g msinsa msinsa -u 1000 \
    && chown -R msinsa:msinsa /app

USER msinsa

# Expose the port
EXPOSE 5000

# Command to run the application
CMD ["python", "aws-iam-checker-app.py"]
