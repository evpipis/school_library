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
            WHERE id = {id} AND is_active = TRUE;
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
@manager_views.route('/lib<id>/manager/books')
@library_exists
@manager_required
def books(id):
    return render_template("manager_books.html", view='manager', id=id)

@manager_views.route('/lib<id>/manager/members', methods = ['GET', 'POST'])
@library_exists
@manager_required
def members(id):
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        password2 = request.form.get('password2')
        role = request.form.get('role')
        # school_id = id
        
        if password != password2:
            flash('Passwords do not match.', category='error')
        else:
            try:
                cur = mydb.connection.cursor()
                cur.execute(f'''
                    INSERT INTO user
                        (username, password, role, school_id, is_active)
                    VALUES
                        ('{username}', '{password}', '{role}', {int(id)}, TRUE);
                ''')
                mydb.connection.commit()
                cur.close()
                flash('Account created successfully.', category='success')
            except Exception as e:
                flash(str(e), category='error')
                print(str(e))

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT username, role
        FROM user
        WHERE school_id = {int(id)} AND is_active = FALSE
            AND (role = 'member-teacher' OR role = 'member-student');
    ''')
    inactive_members_rec = cur.fetchall()

    cur.execute(f'''
        SELECT username, role
        FROM user
        WHERE school_id = {int(id)} AND is_active = TRUE
            AND (role = 'member-teacher' OR role = 'member-student');
    ''')
    active_members_rec = cur.fetchall()
    cur.close()

    inactive_members = list()
    for row in inactive_members_rec:
        inactive_members.append({'username': row[0], 'role': row[1]})
    active_members = list()
    for row in active_members_rec:
        active_members.append({'username': row[0], 'role': row[1]})
    
    return render_template("manager_members.html", view='manager', id=id
                           , inactive_members=inactive_members
                           , active_members=active_members)

@manager_views.route('/lib<id>/manager/borrowings')
@library_exists
@manager_required
def borrowings(id):
    return render_template("manager_borrowings.html", view='manager', id=id)

@manager_views.route('/lib<id>/manager/reviews')
@library_exists
@manager_required
def reviews(id):
    return render_template("manager_reviews.html", view='manager', id=id)

@manager_views.route('/lib<id>/manager/settings', methods = ['GET', 'POST'])
@library_exists
@manager_required
def settings(id):
    if request.method == 'POST':
        # user_id = session['id']
        cur_password = request.form.get('cur_password')
        new_password = request.form.get('new_password')
        rep_password = request.form.get('rep_password')
        
        cur = mydb.connection.cursor()
        cur.execute(f'''
            SELECT password
            FROM user
            WHERE id = {int(session['id'])} AND password = '{cur_password}';
        ''')
        record = cur.fetchall()
        cur.close()

        if not record:
            flash('Current password is not correct.', category='error')
        elif new_password != rep_password:
            flash('New passwords do not match.', category='error')
        elif new_password == cur_password:
            flash('New password is the same as current password.', category='error')
        else:
            try:
                cur = mydb.connection.cursor()
                cur.execute(f'''
                    UPDATE USER
                    SET password = '{new_password}'
                    WHERE id = {int(session['id'])} AND password = '{cur_password}';
                ''')
                mydb.connection.commit()
                cur.close()
                flash('Password changed successfully.', category='success')
            except Exception as e:
                flash(str(e), category='error')
                print(str(e))

    return render_template("manager_settings.html", view='manager', id=id)