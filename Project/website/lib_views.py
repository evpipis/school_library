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
                    AND schoolId = {id}
                    AND isActive = TRUE;
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

@lib_views.route('/lib<id>',methods=['GET','POST'])
@lib_views.route('/lib<id>/index',methods=['GET','POST'])
@library_exists
def index(id):
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
            return render_template("lib_index.html", view='lib', id=id, schoolname = schoolname[0], lib_books = selected_books)
        else:
            flash('Books not Found!', category='error')
            
    return render_template("lib_index.html", view='lib', id=id, schoolname = schoolname[0], lib_books = lib_books)


@lib_views.route('/lib<id>/book<bookid>',methods=['GET',"POST"])
def preview(id, bookid):
    cur = mydb.connection.cursor()

    cur.execute(f'''SELECT title 
    FROM bookTitle WHERE bookTitle.id = {bookid}''')
    title = cur.fetchone()

    cur.execute(f'''SELECT isbn 
    FROM bookTitle WHERE bookTitle.id = {bookid}''')
    isbn = cur.fetchone()

    cur.execute(f'''SELECT authorName
    FROM author INNER JOIN bookAuthors
    ON author.id = bookAuthors.authorId
    WHERE bookAuthors.bookTitleId = {bookid}''' )
    authors = [row[0] for row in cur.fetchall()]

    cur.execute(f'''SELECT category
    FROM categories INNER JOIN bookCategories
    ON categories.id =  bookCategories.bookCategoryId
    WHERE bookCategories.bookTitleId = {bookid}''' )
    categories = [row[0] for row in cur.fetchall()]
    print(categories)

    cur.execute(f''' SELECT summary 
    FROM bookTitle WHERE bookTitle.id = {bookid}''')
    summary = [row[0] for row in cur.fetchall()]
    

    cur.close()
    return render_template("book_preview.html", view='lib',id = id, bookid=bookid ,title = title[0], isbn = isbn[0], authors = authors, categories = categories, summary = summary[0])