from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os

# Load environment variables
MYSQL_USER = os.getenv("MYSQL_USER", "crud_user")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "crud_password")
MYSQL_DB = os.getenv("MYSQL_DB", "crud_db")
MYSQL_HOST = os.getenv("MYSQL_HOST", "db")
MYSQL_PORT = os.getenv("MYSQL_PORT", "3306")

DATABASE_URL = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()