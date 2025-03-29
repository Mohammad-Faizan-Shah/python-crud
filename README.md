# Python CRUD Application

A simple CRUD (Create, Read, Update, Delete) application built with FastAPI, SQLAlchemy, and MySQL.

## Features

- RESTful API with FastAPI
- MySQL database integration
- Docker containerization
- Swagger UI documentation

## Prerequisites

- Python 3.9+
- MySQL
- Docker and Docker Compose (optional)

## Getting Started

### Option 1: Running with Docker (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/python-crud.git
   cd python-crud
   ```

2. Start the application using Docker Compose:
   ```bash
   docker-compose up
   ```

3. Access the API at http://localhost:8000
4. Access the Swagger documentation at http://localhost:8000/docs

### Option 2: Running Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/python-crud.git
   cd python-crud
   ```

2. Create and activate a virtual environment:
   ```bash
   # On macOS/Linux
   python -m venv venv
   source venv/bin/activate

   # On Windows
   python -m venv venv
   venv\Scripts\activate
   ```

3. Install the required dependencies:
   ```bash
   pip install -r app/requirements.txt
   ```

4. Set up MySQL:
   - Ensure MySQL is running on your machine
   - Create a database named `crud_db`
   - Create a user `crud_user` with password `crud_password` (or update the environment variables)
   - Run the SQL script to create tables and sample data:
     ```bash
     mysql -u crud_user -p crud_db < init.sql
     ```

5. Set environment variables:
   ```bash
   # On macOS/Linux
   export MYSQL_USER=crud_user
   export MYSQL_PASSWORD=crud_password
   export MYSQL_DB=crud_db
   export MYSQL_HOST=localhost
   export MYSQL_PORT=3306

   # On Windows
   set MYSQL_USER=crud_user
   set MYSQL_PASSWORD=crud_password
   set MYSQL_DB=crud_db
   set MYSQL_HOST=localhost
   set MYSQL_PORT=3306
   ```

6. Run the application:
   ```bash
   cd app
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

7. Access the API at http://localhost:8000
8. Access the Swagger documentation at http://localhost:8000/docs

### Option 3: Deploying to Kubernetes with Helm

#### Prerequisites for Kubernetes Deployment

1. A Kubernetes cluster (v1.19+)
2. Helm 3+ installed
3. MySQL database in Kubernetes
4. Prometheus monitoring stack installed

#### Setting up MySQL in Kubernetes

You need a MySQL database for the CRUD application to store data. You can deploy MySQL using the mysql-innodbcluster Helm chart:

1. Add the MySQL Operator Helm repository:
   ```bash
   helm repo add mysql-operator https://mysql.github.io/mysql-operator/
   helm repo update
   ```

2. Install MySQL InnoDB Cluster:
   ```bash
   helm install mysql mysql-operator/mysql-innodbcluster \
     --set credentials.root.password=rootpassword \
     --set credentials.root.host='%' \
     --set serverInstances=1 \
     --set podAnnotations."prometheus\.io/scrape"=true
   ```

3. Create a database and user for the CRUD application:
   
   # Connect to MySQL and create database and user
   kubectl exec -it mysql-innodbcluster-0 -- mysql -uroot -prootpassword -e "
   CREATE DATABASE crud_db;
   CREATE USER 'crud_user'@'%' IDENTIFIED BY 'crud_password';
   GRANT ALL PRIVILEGES ON crud_db.* TO 'crud_user'@'%';
   FLUSH PRIVILEGES;"
   ```

#### Setting up Prometheus Monitoring Stack

The CRUD application exposes Prometheus metrics that can be collected and visualized. Install the kube-prometheus-stack for comprehensive monitoring:

1. Add the Prometheus community Helm repository:
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

2. Install kube-prometheus-stack:
   ```bash
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --set grafana.adminPassword=admin \
     --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
   ```

3. A ServiceMonitor for the CRUD application will create CRUD Helm:
 

4. Access Prometheus and Grafana:
   ```bash
   # Port-forward Prometheus
   kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090
   # Access at http://localhost:9090
   
   # Port-forward Grafana
   kubectl port-forward svc/prometheus-grafana 3000:80
   # Access at http://localhost:3000 (user: admin, password: admin)
   ```

#### Deploying the CRUD Application

1. Create a Kubernetes secret for MySQL credentials:
   ```bash
   kubectl create secret generic mysql-secret --from-literal=MYSQL_PASSWORD=crud_password
   ```

2. Install the application using the Helm chart:
   ```bash
   # From the project root directory
   helm install crud-app ./helm-chart \
     --set EnvVars.MYSQL_HOST=mysql-innodbcluster \
     --set EnvVars.MYSQL_USER=crud_user \
     --set EnvVars.MYSQL_DB=crud_db \
     --set EnvVars.MYSQL_PORT=6446
   ```

3. Access the application:
   ```bash
   # If using Ingress
   # Add the following to your /etc/hosts file:
   # 127.0.0.1 crud-app.local
   
   # Then access: http://crud-app.local
   
   # Or use port-forwarding
   kubectl port-forward svc/crud-app 8000:80
   # Then access: http://localhost:8000
   ```

## Project Structure
   ```bash
   python-crud/
   ├── app/
   │ ├── crud.py             # CRUD operations
   │ ├── database.py         # Database connection
   │ ├── main.py             # FastAPI application
   │ ├── models.py           # SQLAlchemy models
   │ ├── requirements.txt    # Python dependencies
   │ └── schemas.py          # Pydantic schemas
   ├── Dockerfile            # Docker configuration
   ├── docker-compose.yml    # Docker Compose configuration
   ├── init.sql              # SQL initialization script
   └── README.md             # Project documentation
  ```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /users/  | List all users |
| GET    | /users/{user_id} | Get a specific user |
| POST   | /users/  | Create a new user |
| PUT    | /users/{user_id} | Update a user |
| DELETE | /users/{user_id} | Delete a user |

## Sample API Usage

### List all users

   ```bash
   curl -X GET http://localhost:8000/users/
   ```

### Get a specific user

   ```bash
    curl -X GET http://localhost:8000/users/1
   ```

### Create a new user
   ```bash
    curl -X POST http://localhost:8000/users/ \
    -H "Content-Type: application/json" \
    -d '{"name": "New User", "email": "newuser@example.com"}'
   ```

### Update a user

   ```bash
    curl -X PUT http://localhost:8000/users/1 \
    -H "Content-Type: application/json" \
    -d '{"name": "Updated Name", "email": "updated@example.com"}'  
   ```


### Delete a user   

   ```bash 
    curl -X DELETE http://localhost:8000/users/1
   ```

## Monitoring

The application includes a monitoring stack with Prometheus and Grafana.

### Accessing Prometheus

1. Access the Prometheus UI at http://localhost:9090
2. Use this interface to:
   - Query metrics using PromQL
   - View targets and their health
   - Check configured alert rules

### Accessing Grafana

1. Access the Grafana dashboard at http://localhost:3000
2. Login credentials:
   - Username: `admin`
   - Password: `crud@123`
3. The CrudApp dashboard is pre-configured with panels for:
   - Application uptime
   - CPU and memory usage
   - HTTP request rates and response times
   - Request/response sizes

### Testing Alerts

You can test the monitoring alerts by:

1. Stopping the CRUD app container:
   ```bash
   docker stop crud-app
   ```

2. After approximately 2 minutes, the "AppDown" alert will trigger in Prometheus
   - View active alerts at http://localhost:9090/alerts

3. Restart the container to resolve the alert:
   ```bash
   docker start crud-app
   ```

### Available Metrics

The application exposes various metrics including:
- `http_requests_total` - Total number of HTTP requests by status code
- `http_request_duration_seconds` - HTTP request latency distribution
- `process_resident_memory_bytes` - Memory usage of the application
- `process_cpu_seconds_total` - CPU usage of the application

