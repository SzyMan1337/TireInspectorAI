from flask import Blueprint, render_template, redirect, url_for, session, current_app

support_bp = Blueprint("support_bp", __name__)


# Redirect to support page
@support_bp.route("/")
def home():
    return redirect(url_for("support_bp.support"))


# Support page route
@support_bp.route("/support")
def support():
    lang = session.get("lang", "en")  # Get the current language from session
    translations = current_app.config["translations"]  # Load translations
    texts = translations.get(
        lang, translations["en"]
    )  # Fallback to 'en' if language not found
    firebase_apk_link = "https://firebasestorage.googleapis.com/v0/b/tireinspectorai.appspot.com/o/android%2Fapp-release.apk?alt=media"
    return render_template(
        "support.html", texts=texts, firebase_apk_link=firebase_apk_link
    )


# Privacy Policy page route
@support_bp.route("/privacy-policy")
def privacy_policy():
    lang = session.get("lang", "en")
    translations = current_app.config["translations"]
    texts = translations.get(lang, translations["en"])
    return render_template("privacy_policy.html", texts=texts)


# Language switch route
@support_bp.route("/switch_language/<lang>")
def switch_language(lang):
    session["lang"] = lang  # Store selected language in session
    return redirect(url_for("support_bp.support"))
