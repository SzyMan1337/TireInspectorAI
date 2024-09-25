from app import create_app
from flask import Flask

# Make sure the app is exposed to Gunicorn
app = create_app()

# For local testing
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
