from flask import Blueprint, render_template

support_bp = Blueprint('support_bp', __name__)

# Support page route
@support_bp.route('/support')
def support():
    return render_template('support.html')
