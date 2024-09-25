from flask import Flask


def create_app():
    app = Flask(__name__)

    # Import the routes (blueprint for predictions)
    from .predict import model_bp

    app.register_blueprint(model_bp)

    return app
