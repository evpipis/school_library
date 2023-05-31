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

@manager_views.route('/lib<id>/manager',methods=['GET','POST'])
@manager_views.route('/lib<id>/manager/books',methods=['GET','POST'])
@library_exists
@manager_required
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
            return render_template("manager_books.html", view='manager', id=id, schoolname = schoolname[0], lib_books = selected_books)
        else:
            flash('Books not Found!', category='error')
            
    return render_template("manager_books.html", view='manager', id=id, schoolname = schoolname[0], lib_books = lib_books)

@manager_views.route('/lib<id>/manager/members')
@library_exists
@manager_required
def members(id):
    return render_template("manager_members.html", view='manager', id=id)

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

@manager_views.route('/lib<id>/manager/settings')
@library_exists
@manager_required
def settings(id):
    return render_template("manager_settings.html", view='manager', id=id)


@manager_views.route('/lib<id>/manager/add_book',methods=['GET','POST'])
@library_exists
@manager_required
def add_book(id):
     if request.method=='POST':
       
            title = request.form.get('title')
            num_of_copies = request.form.get('num_of_copies')

            isbn = request.form.get('isbn')
            lang_id = request.form.get('lang_id')
            authors = request.form.get('authors')
            categories = request.form.get('categories')
            publisher = request.form.get('publisher')
            num_of_pages = request.form.get('num_of_pages')
            keywords = request.form.get('keywords')
            image = request.form.get('image')
            summary = request.form.get('summary')
            
            print(title, num_of_copies,isbn,lang_id,authors,categories,publisher,num_of_pages,keywords,image,summary)
            
            cur = mydb.connection.cursor()

            cur.execute(f'''
            SELECT bookTitle.id FROM bookTitle
            WHERE title = '{title}' ''')
            title_id = cur.fetchone()

            if(title_id==None):
                if (title==None or num_of_copies==None or isbn==None or lang_id==None or authors==None or categories==None or 
                    publisher==None or num_of_pages==None or keywords==None or image==None or summary==None):
                    flash('This book title doesn\'t exist. Complete all forms', category='error')
                    return render_template("manager_add_book.html", view='manager',id=id, book_exists = False) 
                else:
                     cur.execute('''
                     INSERT INTO bookTitle (title, publisher, isbn, summary, image, langId, numberOfPages)
                     VALUES (%s, %s, %s, %s, %s, %s, %s);''',
                     (title, publisher, isbn, summary, image, lang_id, num_of_pages) )
                     mydb.connection.commit()  

                     cur.execute(f'''
                     SELECT id FROM bookTitle 
                     WHERE bookTitle.title = '{title}' ''')
                     bookid = cur.fetchone()
                     
                     for author in authors.split(','):
                          cur.execute(f'''
                          CALL revise_authors('{author}',{bookid[0]})''')

                     for category in categories.split(','):
                          cur.execute(f'''
                          CALL revise_categories('{category}',{bookid[0]})''')
                     
                    # for keyword in keywords.split(','):
                         # cur.execute(f'''
                         # CALL revise_keywords('{keyword}',{bookid[0]})''')  
            
                     cur.execute('''
                     INSERT INTO bookCopy 
                        (bookTitleId, schoolUnitId, numberOfCopies)
                     VALUES 
                        (%s, %s, %s); ''',
                        (bookid, id, num_of_copies) )  
                     mydb.connection.commit()
                     cur.close()

                     flash('New Book title added successfully!', category='success')
                     return redirect(url_for('manager_views.books', id=id))           

            else:
                cur.execute(f'''
                SELECT bookCopy.id FROM bookCopy 
                WHERE bookCopy.schoolUnitId = {id} 
                AND bookCopy.bookTitleId = {title_id[0]} ''')
                copy_id = cur.fetchone()

                if (copy_id==None):
                    print(title_id[0], id, num_of_copies)
                    cur.execute('''
                    INSERT INTO bookCopy 
                        (bookTitleId, schoolUnitId, numberOfCopies)
                    VALUES 
                        (%s, %s, %s); ''',(title_id[0], id, num_of_copies)
                    )
                    mydb.connection.commit()
                    cur.close()

                    flash('Book added to school\'s library successfully!', category='success')
                    return redirect(url_for('manager_views.books', id=id))
                
                else:
                    cur.execute('''
                    UPDATE bookCopy 
                    SET numberOfCopies = %s 
                    WHERE id = %s; ''', 
                    (num_of_copies, copy_id[0]) )
                    mydb.connection.commit()
                    cur.close()

                    flash('Book already exists in school\'s library. Updated number of copies successfully!', category='info')
                    return redirect(url_for('manager_views.books', id=id))

     return render_template("manager_add_book.html", view='manager',id=id, book_exists = True)     


