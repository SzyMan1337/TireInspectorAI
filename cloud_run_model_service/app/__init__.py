from flask import Flask
from .predict import model_bp
from .support import support_bp

def create_app():
    app = Flask(__name__)

    app.register_blueprint(model_bp)
    app.register_blueprint(support_bp)

    return app
