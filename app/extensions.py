import pymysql
from pymysql.cursors import DictCursor
from flask import current_app, g

class MySQL:
    def __init__(self, app=None):
        if app is not None:
            self.init_app(app)

    def init_app(self, app):
        @app.teardown_appcontext
        def teardown_db(exception):
            db = g.pop('db', None)
            if db is not None:
                db.close()

    @property
    def connection(self):
        if 'db' not in g:
            cursor_class = pymysql.cursors.Cursor
            if current_app.config.get("MYSQL_CURSORCLASS") == "DictCursor":
                cursor_class = DictCursor

            g.db = pymysql.connect(
                host=current_app.config.get("MYSQL_HOST", "localhost"),
                user=current_app.config.get("MYSQL_USER", "root"),
                password=current_app.config.get("MYSQL_PASSWORD", ""),
                database=current_app.config.get("MYSQL_DB", ""),
                cursorclass=cursor_class,
                autocommit=False
            )
        else:
            g.db.ping(reconnect=True)
        return g.db

mysql = MySQL()
