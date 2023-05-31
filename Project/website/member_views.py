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
            FROM schoolUnit
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

@member_views.route('/lib<id>/member', methods = ['GET','POST'])
@member_views.route('/lib<id>/member/books', methods = ['GET','POST'])
@library_exists
@member_required
def books(id):
    cur = mydb.connection.cursor()
    cur.execute(f'''
    SELECT schoolName 
    FROM schoolUnit
    WHERE schoolUnit.id = {id} ''')
    schoolname = cur.fetchone()

    cur.execute(f'''
    SELECT title, numberOfCopies, bookTitle.id
    FROM BookTitle INNER JOIN BookCopy 
    ON BookTitle.id = BookCopy.BookTitleId 
    WHERE BookCopy.schoolUnitId = {id} ''')
    lib_books = cur.fetchall()

    if request.method=='POST':
        cur = mydb.connection.cursor()
        cur.execute(f'''
        SELECT schoolName 
        FROM schoolUnit
        WHERE schoolUnit.id = {id} ''')
        schoolname = cur.fetchone()

        filter = request.form.get('filter')
        keyword = request.form.get('search_book')
        print(filter)
        print(keyword)

        if (filter == 'title'):
                cur.execute (f'''
                CALL filter_title({id}, '{keyword}')''')
        if (filter == 'category'):
                cur.execute(f'''
                CALL filter_category ({id} , '{keyword}') ''')
        if (filter == 'author'):
                cur.execute(f'''
                CALL filter_author ({id} , '{keyword}') ''')

        selected_books = cur.fetchall()
        print(selected_books)
        if (selected_books!= ()):
            cur.close()
            return render_template("lib_index.html", view='member', id=id, schoolname = schoolname[0], lib_books = selected_books)
        else:
            flash('Books not Found!', category='error')
            
    return render_template("lib_index.html", view='member', id=id, schoolname = schoolname[0], lib_books = lib_books)


@member_views.route('/lib<id>/member/my_borrowings')
@library_exists
@member_required
def my_borrowings(id):
    cur = mydb.connection.cursor()
    user_id = session.get('id')
    cur.execute(f'''
    SELECT bookTitle.title, borrow.borrowingDate, borrow.returnDate, borrow.maxBorrowingTime FROM
    borrow INNER JOIN bookCopy ON borrow.bookId = bookCopy.id
    INNER JOIN bookTitle ON bookCopy.bookTitleId = bookTitle.id
    WHERE borrow.userId = {user_id} ''')
    borrow_data = cur.fetchall()
    cur.close()
    return render_template("member_my_borrowings.html", view='member', id=id, borrow_data = borrow_data)

@member_views.route('/lib<id>/member/my_reviews')
@library_exists
@member_required
def my_reviews(id):
    cur = mydb.connection.cursor()
    user_id = session.get('id')
    cur.execute(f'''
    SELECT bookTitle.title, review.numberOfStars, review.opinion FROM 
    review INNER JOIN bookTitle ON review.bookTitleId = bookTitle.id
    WHERE userId = {user_id}''')
    my_reviews =  cur.fetchall()
    
    return render_template("member_my_reviews.html", view='member', id=id, my_reviews = my_reviews)

@member_views.route('/lib<id>/member/settings')
@library_exists
@member_required
def settings(id):
    return render_template("member_settings.html", view='member', id=id)