from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from functools import wraps
from . import mydb

manager_views = Blueprint('manager_views', __name__)

### authentication requirements

def library_exists(f):
    @wraps(f)
    def decorated_function(id, *args, **kwargs):
        print(f"library_exists {id}")
        cur = mydb.connection.cursor()
        cur.execute(f'''
            SELECT id
            FROM school_unit
            WHERE id = {id};
        ''')
        record = cur.fetchall()
        cur.close()

        if record:
            return f(id, *args, **kwargs)
        flash(f'No library with id = {id}.', category='error')
        return redirect(url_for('init_views.index')) # the '/' page
    return decorated_function

def manager_required(f):
    @wraps(f)
    def decorated_function(id, *args, **kwargs):
        print(f"manager_required {id}")
        # if manager cookies
        if session.get('school_id') == int(id) and session.get('role') == 'manager':
            return f(id, *args, **kwargs)
        flash('Access denied.', category='error')
        return redirect(url_for('lib_views.index', id=id)) # the '/' page
    return decorated_function

### authentication views

@manager_views.route('/lib<id>/manager/logout')
@library_exists
@manager_required
def logout(id):
    session.pop('id', None)
    session.pop('username', None)
    session.pop('role', None)
    session.pop('school_id', None)
    
    return redirect(url_for('lib_views.login', id=id))

### operations views

@manager_views.route('/lib<id>/manager')
@manager_views.route('/lib<id>/manager/operations')
@library_exists
@manager_required
def operations(id):
    return render_template("manager_operations.html", view='manager', id=id)