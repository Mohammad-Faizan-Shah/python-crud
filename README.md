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
