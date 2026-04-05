import os
from flask import Flask, redirect, url_for
from dotenv import load_dotenv

from app.extensions import mysql
from app.routes.auth_routes import auth_bp
from app.routes.user_routes import user_bp
from app.routes.live_routes import live_bp
from app.routes.shift_report import shift_report_bp


# Load .env file if it exists
load_dotenv()


def create_app():
    app = Flask(__name__)

    # =========================
    # SECRET KEY
    # =========================
    app.secret_key = os.environ.get("SECRET_KEY", "super_secret_key_change_later")

    # =========================
    # MYSQL CONFIG
    # =========================
    app.config["MYSQL_HOST"] = os.environ.get("MYSQL_HOST", "localhost")
    app.config["MYSQL_USER"] = os.environ.get("MYSQL_USER", "root")
    app.config["MYSQL_PASSWORD"] = os.environ.get("MYSQL_PASSWORD", "password")
    app.config["MYSQL_DB"] = os.environ.get("MYSQL_DB", "cognitive_load_db")
    app.config["MYSQL_CURSORCLASS"] = "DictCursor"

    mysql.init_app(app)

    # =========================
    # PRESENCE TRACKER
    # =========================
    from app.utils.presence import tracker
    from flask import session, request

    @app.before_request
    def update_presence():
        if "user_id" in session:
            tracker.update_seen(session["user_id"])

    # =========================
    # ROOT ROUTE
    # =========================
    @app.route("/")
    def index():
        return redirect(url_for("auth.login"))

    # =========================
    # BLUEPRINTS
    # =========================
    app.register_blueprint(auth_bp)
    app.register_blueprint(user_bp)
    app.register_blueprint(live_bp)
    app.register_blueprint(shift_report_bp)

    from app.routes.shift_history import shift_history_bp
    app.register_blueprint(shift_history_bp)

    from app.routes.admin_routes import admin_bp
    app.register_blueprint(admin_bp)

    # ✅ capture_controller handles all monitoring logic

    return app


