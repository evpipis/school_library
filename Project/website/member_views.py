from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from functools import wraps
from . import mydb

member_views = Blueprint('member_views', __name__)

### authentication requirements

def library_exists(f):
    @wraps(f)
    def decorated_function(id, *args, **kwargs):
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

def member_required(f):
    @wraps(f)
    def decorated_function(id, *args, **kwargs):
        # if manager cookies
        if session.get('school_id') == int(id) and (session.get('role') == 'member-student' or session.get('role') == 'member-teacher'):
            return f(id, *args, **kwargs)
        flash('Access denied.', category='error')
        return redirect(url_for('lib_views.index', id=id)) # the '/lib' page
    return decorated_function

### authentication views

@member_views.route('/lib<id>/member/logout')
@library_exists
@member_required
def logout(id):
    session.pop('id', None)
    session.pop('username', None)
    session.pop('role', None)
    session.pop('school_id', None)
    
    return redirect(url_for('lib_views.login', id=id))

### operations views

@member_views.route('/lib<id>/member')
@member_views.route('/lib<id>/member/operations')
@library_exists
@member_required
def operations(id):
    return render_template("member_operations.html", view='member', id=id)