# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy application code and requirements file
COPY ./app /app

# Install dependencies
RUN pip install --no-cache-dir -r pip-packages.txt

# Expose the port
EXPOSE 5000

# Command to run the application
CMD ["python", "iam-check.py"]