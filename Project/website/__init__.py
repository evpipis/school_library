from flask import Flask
from flask_mysqldb import MySQL
from . import config

mydb = None

def create_app():
    app = Flask(__name__)
    # encrypt/secure cookies in session data related to our website
    app.config['SECRET_KEY'] = config.secret_key
    app.config['MYSQL_HOST'] = config.mysql_host
    app.config['MYSQL_USER'] = config.mysql_user
    app.config['MYSQL_PASSWORD'] = config.mysql_password
    app.config['MYSQL_DB'] = config.mysql_db
    # no need to configure the port because it is located in 3306
    # this port is the port usually selected by MYSQL databases

    create_database(app)

    from .init_views import init_views
    from .admin_views import admin_views
    from .lib_views import lib_views
    from .manager_views import manager_views
    from .member_views import member_views

    # TODO: change url_prefixes for _views
    app.register_blueprint(init_views, url_prefix='/')
    app.register_blueprint(admin_views, url_prefix='/')
    app.register_blueprint(lib_views, url_prefix='/')
    app.register_blueprint(manager_views, url_prefix='/')
    app.register_blueprint(member_views, url_prefix='/')

    return app


# here I can create the database
def create_database(app):
    global mydb
    mydb = MySQL(app)
    