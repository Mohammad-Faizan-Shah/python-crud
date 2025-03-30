# Python CRUD Application

A simple CRUD (Create, Read, Update, Delete) application built with FastAPI, SQLAlchemy, and MySQL.

## CI/CD Pipeline

This project includes a GitHub Actions workflow that automatically builds and pushes images to the registry when code is pushed to the main branch.

### GitHub Actions Workflow

The workflow performs the following steps:
- Builds the Docker image
- Pushes the image to Docker Hub

You can view the workflow configuration in `.github/workflows/main.yml`:


## Features

- RESTful API with FastAPI
- MySQL database integration
- Docker containerization
- Swagger UI documentation

## Project Structure
   ```bash
   python-crud/
   ├── app/
   │ ├── crud.py             # CRUD operations
   │ ├── database.py         # Database connection
   │ ├── db/                 # Database related files
   │ ├── grafana/            # Grafana dashboards and configs
   │ ├── main.py            # FastAPI application
   │ ├── models.py          # SQLAlchemy models
   │ ├── prometheus/        # Prometheus configs and rules
   │ ├── requirements.txt   # Python dependencies
   │ └── schemas.py         # Pydantic schemas
   ├── Dockerfile           # Docker configuration
   ├── docker-compose.yml   # Docker Compose configuration
   ├── helm-chart/         # Helm chart for k8s deployment
   ├── ingressLB.yaml      # Ingress Load Balancer config
   ├── kube-prometheus-stack/ # Prometheus operator stack
   ├── terraform-eks/      # Terraform EKS configuration
   └── README.md           # Project documentation
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

## Prerequisites

- Python 3.9+
- MySQL
- Docker and Docker Compose 

## Getting Started

### Option 1: Running with Docker (Simplest)

1. Clone the repository:
   ```bash
   git clone https://github.com/Mohammad-Faizan-Shah/python-crud.git
   cd python-crud
   ```

2. Start the application using Docker Compose:
   ```bash
   docker-compose up --build
   ```

3. Access the services:
   - CRUD Application: http://localhost:8000
   - Grafana Dashboard: http://localhost:3000 (login with admin/crud@123)
   - Prometheus: http://localhost:9090

4. Monitor the application:
   - View pre-configured CrudApp dashboards in Grafana showing:
     - Application uptime
     - CPU and memory usage 
     - HTTP request rates and latencies
     - System metrics

5. Test alerting:
   - Stop the application container:
     ```bash
     docker stop crud-app
     ```
   - Check Prometheus alerts at http://localhost:9090/alerts
   - After ~2 minutes, you should see the AppDown alert trigger
   - Restart the container to resolve the alert:
     ```bash
     docker start crud-app
     ```

### Option 2: Deploying to AWS EKS with Terraform and Helm

#### Prerequisites for AWS EKS Deployment

1. AWS CLI configured with appropriate credentials
2. Terraform installed
3. Helm 3+ installed
4. kubectl installed

Follow the Cloud Infra Setup guide in [terraform-eks/README.md](terraform-eks/README.md) to:

1. Deploy an EKS cluster and RDS MySQL database using Terraform
2. Configure kubectl to connect to your EKS cluster
3. Set up the necessary IAM roles and policies

### Deploying the Component required to run CRUD Application

#### Setting up Ingress-Nginx Controller

1. Deploy the Ingress-Nginx controller for AWS:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/aws/deploy.yaml
   ```

   Wait for the Load Balancer to be provisioned:
   ```bash
   kubectl get svc -n ingress-nginx
   ```
   
   You should see an external IP/hostname for the `ingress-nginx-controller` service. This is your application's entry point.

2. Create a Kubernetes secret for MySQL credentials:
   ```bash
   kubectl create secret generic mysql-secret --from-literal=MYSQL_PASSWORD="DBPASS"
   ```
     Use the same password you set in terraform.tfvars for the RDS instance

3. Create a Docker registry secret for pulling private images:
   ```bash
   kubectl create secret docker-registry my-docker-secret \
     --docker-server=<your-registry-url> \
     --docker-username=<your-username> \
     --docker-password=<your-password> \
     --docker-email=<your-email>
   ```

   Patch the default service account to use this secret:
   ```bash
   kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "my-docker-secret"}]}'
   ```

#### Setting up Prometheus Monitoring Stack

The CRUD application exposes Prometheus metrics that can be collected and visualized. Install the kube-prometheus-stack for comprehensive monitoring:

1. Install kube-prometheus-stack:
   ```bash
   helm install prometheus kube-prometheus-stack/ 
   ```

   You can customize the hostnames for Prometheus and Grafana during installation:
   ```bash
   helm install prometheus kube-prometheus-stack/ \
     --set prometheus.ingress.hosts[0]=prometheus.example.com \
     --set grafana.ingress.hosts[0]=grafana.example.com
   ```

2. By default, the chart will create ingress resources for both Prometheus and Grafana with the following hostnames:
   - Prometheus: prometheus.local.com
   - Grafana: grafana.local.com

4. Get the Grafana admin password if you didn't set a custom one:
   ```bash
   kubectl get secret prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d; echo
   ```

📌 Note: A pre-configured CrudApp Grafana dashboard will be installed automatically. You can access it after deploying the application.


#### Deploying the CRUD Application

1. The Helm chart will create an Ingress resource for the application with the following hostname:
   - CRUD App: crud-app.local.com

   You can customize the hostname during installation:
   ```bash
   helm install crud-app ./helm-chart \
     --set ingress.hosts[0]=your-custom-domain.com \
     --set EnvVars.MYSQL_HOST="<your-mysql-endpoint-from-terraform>" \
     --set EnvVars.MYSQL_USER="<mysql-user>" \
     --set EnvVars.MYSQL_DB="<mysql-db-from-terraform>" \
     --set EnvVars.MYSQL_PORT=3306
   ```
 📌 Notes: A pre-configured ServiceMonitor for the CRUD application will be created with Helm to scrap metrics from CrudApp


## Access the Application and Monitor

1. If you can't access the ingress LB directly, use port-forwarding:
   ```bash
   kubectl port-forward svc/ingress-nginx-controller 80:80 --address=0.0.0.0 -n ingress-nginx
   ```   
2. Access the Application Monitoring Services:
    Add the following to your /etc/hosts file:
   ```bash
    127.0.0.1 crud-app.local.com grafana.local.com prometheus.local.com
   ```
### Accessing CrudApp

1. Access the CRUD application at http://crud-app.local.com

2. Using curl to interact with the API:
   ```bash
   # Create a new item
   curl -X POST http://crud-app.local.com/items \
     -H "Content-Type: application/json" \
     -d '{"name": "test item", "description": "test description"}'

   # Get all items
   curl http://crud-app.local.com/items

   # Get a specific item
   curl http://crud-app.local.com/items/{id}

   # Update an item
   curl -X PUT http://crud-app.local.com/items/{id} \
     -H "Content-Type: application/json" \
     -d '{"name": "updated item", "description": "updated description"}'

   # Delete an item
   curl -X DELETE http://crud-app.local.com/items/{id}
   ```

3. Using Swagger UI:
   - Access the Swagger documentation at http://crud-app.local.com/docs
   - The interactive UI allows you to:
     - View all available API endpoints
     - Test API operations directly from the browser
     - See request/response schemas
     - Execute requests and view responses in real-time

### Accessing Grafana

1. Access the Grafana dashboard at http://grafana.local.com
   - Username: `admin`
   - Password: `YouFetchedWhileDeploying` 
2. The CrudApp dashboard is pre-configured with panels for:
   - Application uptime
   - CPU and memory usage
   - HTTP request rates and response times
   - Request/response sizes     

### Accessing Prometheus

1. Access the Prometheus UI at http://prometheus.local.com
2. Use this interface to:
   - Query metrics using PromQL
   - View targets and their health
   - Check configured alert rules