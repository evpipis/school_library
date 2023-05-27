from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from functools import wraps
from . import mydb

lib_views = Blueprint('lib_views', __name__)

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

def guest_required(f):
    @wraps(f)
    def decorated_function(id, *args, **kwargs):
        # if guest cookies
        if session.get('role') is None:
            return f(id, *args, **kwargs)
        flash('Access denied.', category='error')
        return redirect(url_for('lib_views.index', id=id)) # the '/' page
    return decorated_function

### authentication views

@lib_views.route('/lib<id>/login', methods=['GET', 'POST'])
@library_exists
@guest_required
def login(id):
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        role = request.form.get('role')
        print(username)
        print(password)
        print(role)

        try:
            cur = mydb.connection.cursor()
            cur.execute(f'''
                SELECT id
                FROM user
                WHERE username = '{username}' 
                    AND password = '{password}'
                    AND role = '{role}'
                    AND school_id = {id}
                    AND is_active = TRUE;
            ''')
            record = cur.fetchall()
            # commit() not needed for SELECTS!
            # mydb.connection.commit()
            cur.close()

            if record:
                session['id'] = record[0][0]
                session['username'] = username
                session['role'] = role
                session['school_id'] = int(id)

                flash('Sucessful login!', category='success')
                if role == 'manager':
                    return redirect(url_for('manager_views.books', id=id))
                elif role == 'member-student' or role == 'member-teacher':
                    return redirect(url_for('member_views.books', id=id))
                else:
                    flash('Login failed!', category='error')
            else:
                flash('Login failed!', category='error')
            # add admin pages
            # return redirect(url_for("index"))
        except Exception as e: # change this category to danger!!!
            flash(str(e), category='error')
            print(str(e))
    return render_template("lib_login.html", view='lib', id=id)

@lib_views.route('/lib<id>/sign_up', methods=['GET', 'POST'])
@library_exists
@guest_required
def sign_up(id):
    return render_template("lib_sign_up.html", view='lib', id=id)

### operations views

@lib_views.route('/lib<id>')
@lib_views.route('/lib<id>/index')
@library_exists
def index(id):
    return render_template("lib_index.html", view='lib', id=id)