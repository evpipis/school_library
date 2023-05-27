from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from functools import wraps
from . import mydb

admin_views = Blueprint('admin_views', __name__)

### authentication requirements

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # if admin cookies
        if session.get('role') == 'admin':
            return f(*args, **kwargs)
        flash('Access denied.', category='error')
        return redirect(url_for('init_views.index')) # the '/' page
    return decorated_function

### authentication views

@admin_views.route('/admin/logout')
@admin_required
def logout():
    session.pop('id', None)
    session.pop('username', None)
    session.pop('role', None)
    session.pop('school_id', None)
    
    return redirect(url_for('init_views.admin_login'))

### operations views

@admin_views.route('/admin')
@admin_views.route('/admin/libraries')
@admin_required
def libraries():
    return render_template("admin_libraries.html", view='admin')

@admin_views.route('/admin/managers')
@admin_required
def managers():
    return render_template("admin_managers.html", view='admin')

@admin_views.route('/admin/settings')
@admin_required
def settings():
    return render_template("admin_settings.html", view='admin')