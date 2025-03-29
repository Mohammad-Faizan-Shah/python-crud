FROM python:3.9-alpine

# Set the working directory inside the container
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps gcc musl-dev

# Copy requirements and install dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app folder
COPY app/ .

# Expose port 8000
EXPOSE 8000

# Run Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]