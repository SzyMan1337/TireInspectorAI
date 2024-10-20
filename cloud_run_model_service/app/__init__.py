from flask import Flask, session, redirect, url_for
from .predict import model_bp
from .support import support_bp
import json
import os


def create_app():
    app = Flask(__name__)
    app.secret_key = os.urandom(24)

    app.register_blueprint(model_bp)
    app.register_blueprint(support_bp)

    with open(
        os.path.join(os.path.dirname(__file__), "..", "translations.json"),
        "r",
        encoding="utf-8",
    ) as f:
        translations = json.load(f)

    @app.before_request
    def set_default_language():
        if "lang" not in session:
            session["lang"] = "en"

    @app.route("/switch_language/<lang>")
    def switch_language(lang):
        if lang in translations:
            session["lang"] = lang
        return redirect(url_for("support_bp.support"))

    app.config["translations"] = translations

    return app
