from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from functools import wraps
from . import mydb

init_views = Blueprint('init_views', __name__)

### authentication requirements

def guest_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # if guest cookies
        if session.get('role') is None:
            return f(*args, **kwargs)
        flash('Access denied.', category='error')
        return redirect(url_for('init_views.index')) # the '/' page
    return decorated_function

### authentication views

@init_views.route('/admin_login', methods=['GET', 'POST'])
@guest_required
def admin_login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        # !!! normally I should hash the password
        # before sending and storing it in DB !!!

        # try to login here with database login only!
        try:
            cur = mydb.connection.cursor()
            cur.execute(f'''
                SELECT *
                FROM user
                WHERE username = '{username}' 
                    AND password = '{password}'
                    AND role = 'admin'
                    AND is_active = TRUE;
            ''')
            record = cur.fetchall()
            # commit() not needed for SELECTS!
            # mydb.connection.commit()
            cur.close()

            if record:
                # be careful not to change the user table!!!
                session['id'] = record[0][0]
                session['username'] = record[0][1]
                session['role'] = record[0][3]
                session['school_id'] = record[0][4]
                # if not active they should not login!!!
                flash('Sucessful login!', category='success')
                print(session)
                return redirect(url_for('admin_views.libraries'))
            else:
                flash('Login failed!', category='error')
            # add admin pages
            # return redirect(url_for("index"))
        except Exception as e: # change this category to danger!!!
            flash(str(e), category='error')
            print(str(e))
    return render_template("init_admin_login.html", view='init')

@init_views.route('/school_sign_up', methods=['GET', 'POST'])
@guest_required
def school_sign_up():
    if request.method == 'POST':
        name = request.form.get('name')
        address = request.form.get('address')
        city = request.form.get('city')
        phone = request.form.get('phone')
        email = request.form.get('email')
        principal_name = request.form.get('principal_name')

        # put try catch here instead of ifs
        # also print the error messages as a list where they occur
        # but the latter is not that important
        # !!!!! should add is_active or is_approved attribute
        if name == "":
            flash('School name should not be empty', category='error')
        else:
            cur = mydb.connection.cursor()
            cur.execute('''
                INSERT INTO school_unit
                    (name, address, city, phone, email, principal_name, is_active)
                VALUES
                    (%s, %s, %s, %s, %s, %s, FALSE); '''
                ,(name, address, city, phone, email, principal_name)
            )
            mydb.connection.commit()
            cur.close()
            flash('School created successfully.', category='success')
    return render_template("init_school_sign_up.html", view='init')

### operations views

@init_views.route('/')
@init_views.route('/index')
def index():
    # only add is_active schools here
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id, name
        FROM school_unit
        WHERE is_active = TRUE;
    ''')
    record = cur.fetchall()
    cur.close()

    schools = list()
    for row in record:
        schools.append({'id': row[0], 'name': row[1]})
    return render_template("init_index.html", view='init', schools=schools)