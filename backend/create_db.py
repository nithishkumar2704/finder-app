import pymysql
from decouple import config

def create_db():
    try:
        # Connect without database name first
        connection = pymysql.connect(
            host=config('DB_HOST', default='127.0.0.1'),
            user=config('DB_USER', default='root'),
            password=config('DB_PASSWORD', default=''),
            port=int(config('DB_PORT', default=3306))
        )
        
        db_name = config('DB_NAME', default='finder_app_db')
        
        with connection.cursor() as cursor:
            cursor.execute(f"CREATE DATABASE IF NOT EXISTS {db_name}")
            print(f"Successfully created database: {db_name}")
            
        connection.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    create_db()
