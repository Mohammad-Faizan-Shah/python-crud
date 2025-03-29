from fastapi import FastAPI, Depends, HTTPException, status
from prometheus_fastapi_instrumentator import Instrumentator
from sqlalchemy.orm import Session
import models, database, schemas, crud

# Initialize FastAPI app
app = FastAPI()

# Enable Prometheus metrics
Instrumentator().instrument(app).expose(app, endpoint="/metrics")

# Create database tables
models.Base.metadata.create_all(bind=database.engine)

# Dependency to get DB session
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()



@app.post("/users/", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    """Create a new user"""
    return crud.create_user(db, user)

@app.get("/users/", response_model=list[schemas.UserResponse], status_code=status.HTTP_200_OK)
def get_all_users(db: Session = Depends(get_db)):
    """Get all users"""
    users = crud.get_all_users(db)
    return users

@app.get("/users/{user_id}", response_model=schemas.UserResponse, status_code=status.HTTP_200_OK)
def get_user(user_id: int, db: Session = Depends(get_db)):
    """Get a user by ID"""
    db_user = crud.get_user(db, user_id)
    if db_user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return db_user

@app.put("/users/{user_id}", response_model=schemas.UserResponse, status_code=status.HTTP_200_OK)
def update_user(user_id: int, user: schemas.UserUpdate, db: Session = Depends(get_db)):
    """Update a user"""
    updated_user = crud.update_user(db, user_id, user)
    if updated_user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return updated_user

@app.delete("/users/{user_id}", response_model=schemas.UserResponse, status_code=status.HTTP_200_OK)
def delete_user(user_id: int, db: Session = Depends(get_db)):
    """Delete a user"""
    deleted_user = crud.delete_user(db, user_id)
    if deleted_user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return deleted_user
