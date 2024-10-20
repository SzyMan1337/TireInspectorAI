from flask import Blueprint, render_template, redirect, url_for

support_bp = Blueprint("support_bp", __name__)


@support_bp.route("/")
def home():
    return redirect(url_for("support_bp.support"))


# Support page route
@support_bp.route("/support")
def support():
    firebase_apk_link = "https://firebasestorage.googleapis.com/v0/b/tireinspectorai.appspot.com/o/android%2Fapp-release.apk?alt=media"
    return render_template("support.html", firebase_apk_link=firebase_apk_link)


# Privacy Policy page route
@support_bp.route("/privacy-policy")
def privacy_policy():
    return render_template("privacy_policy.html")
