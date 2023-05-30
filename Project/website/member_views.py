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
            WHERE id = {id} AND is_active = TRUE;
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
@member_views.route('/lib<id>/member/books')
@library_exists
@member_required
def books(id):
    return render_template("member_books.html", view='member', id=id)

@member_views.route('/lib<id>/member/my_borrowings')
@library_exists
@member_required
def my_borrowings(id):
    return render_template("member_my_borrowings.html", view='member', id=id)

@member_views.route('/lib<id>/member/my_reviews')
@library_exists
@member_required
def my_reviews(id):
    return render_template("member_my_reviews.html", view='member', id=id)

### settings views

@member_views.route('/lib<id>/member/settings')
@library_exists
@member_required
def settings(id):
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT name, birth_date
        FROM user
        WHERE id = {int(session['id'])};
    ''')
    user_rec = cur.fetchall()
    cur.close()

    user = {'name': user_rec[0][0], 'birth_date': str(user_rec[0][1]), 'role': session['role']}
    return render_template("member_settings.html", view='member', id=id, user=user)

@member_views.route('/lib<id>/member/settings/change_info', methods = ['POST'])
@library_exists
@member_required
def change_info(id):
    name = request.form.get('name')
    birth_date = request.form.get('birth_date')
    print(birth_date)
    try:
        cur = mydb.connection.cursor()
        cur.execute(f'''
            UPDATE USER
            SET name = '{name}', birth_date = '{birth_date}'
            WHERE id = {int(session['id'])};
        ''')
        mydb.connection.commit()
        cur.close()
        flash('Info changed successfully.', category='success')
    except Exception as e:
        flash(str(e), category='error')
        print(str(e))

    return redirect(url_for('member_views.settings', id=id))

@member_views.route('/lib<id>/member/settings/change_password', methods = ['POST'])
@library_exists
@member_required
def change_password(id):
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

    return redirect(url_for('member_views.settings', id=id))