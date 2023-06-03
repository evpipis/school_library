from flask import Blueprint, render_template, request, flash, redirect, url_for, session, jsonify
from functools import wraps
from . import mydb
import json

manager_views = Blueprint('manager_views', __name__)

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

def manager_required(f):
    @wraps(f)
    def decorated_function(id, *args, **kwargs):
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

### books views

@manager_views.route('/lib<id>/manager', methods = ['GET', 'POST'])
@manager_views.route('/lib<id>/manager/books', methods = ['GET', 'POST'])
def books(id):

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT name 
        FROM school_unit
        WHERE id = {id};
    ''')
    schoolname = cur.fetchone()

    cur.execute(f'''
        SELECT title, copies, book_title.id
        FROM book_title INNER JOIN book_instance
        ON book_title.id = book_instance.book_id
        WHERE book_instance.school_id = {id};
    ''')
    lib_books = cur.fetchall()

    cur.execute(f'''
                SELECT category FROM categories''')
    all_categories = [row[0] for row in cur.fetchall()]

    cur.execute(f'''
                SELECT author FROM authors''')
    all_authors = [row[0] for row in cur.fetchall()]

    # if filters applied by user
    if request.method=='POST':
        print("inside POST request")
        cur = mydb.connection.cursor()
        cur.execute(f'''
            SELECT name 
            FROM school_unit
            WHERE id = {id};
        ''')
        schoolname = cur.fetchone()

        filter_author = request.form.get('filter_author')
        filter_category = request.form.get('filter_category')
        filter_title = request.form.get('set_title')
        filter_copies = request.form.get('set_copies')

        print(filter_author)
        print(filter_category)
        print(filter_title==None)
        print(filter_copies=='')

        selected_books=set()

        # assuming title is unique it overwrites other filters...
        if filter_title != '' :
            cur.execute(f'''
                        CALL filter_title ({id},'{filter_title}');
                        ''')
            selected_books = cur.fetchall()

        else:
            
            if filter_author != 'all_books' :
                cur.execute(f'''
                            CALL filter_author({id},'{filter_author}');
                            ''')
                selected_books=set(cur.fetchall())

                if filter_category != 'all_books' :
                    cur.execute(f'''
                                CALL filter_category({id},'{filter_category}');''')
                    selected_books = selected_books.intersection(set(cur.fetchall()))

                if filter_copies != '' :
                    cur.execute(f'''
                                CAll filter_copies({id}, {filter_copies} );
                                ''')
                    selected_books.intersection(set(cur.fetchall()))

            elif filter_category != 'all_books':
                    cur.execute(f'''
                                CALL filter_category({id},'{filter_category}');''')
                    selected_books=set(cur.fetchall())

                    if filter_copies != '' :
                        cur.execute(f'''
                                    CAll filter_copies({id}, {filter_copies} );
                                    ''')
                        selected_books.intersection(set(cur.fetchall()))

            elif filter_copies != '':
                cur.execute(f'''
                            CAll filter_copies({id}, {filter_copies} );
                            ''')
                selected_books = cur.fetchall()             

        cur.close()

        print("cursor_closed")
        print(selected_books)
        if (selected_books!=set() and selected_books != ()):
            flash('Books Search was successfull!', category='success')
            return render_template("manager_books.html", view='manager', id=id, schoolname=schoolname[0], lib_books = selected_books,
                                   all_authors = all_authors, all_categories = all_categories)
        else:
            flash('Books not Found!', category='error')

    cur.close()
    return render_template("manager_books.html", view='manager', id=id, schoolname = schoolname[0], lib_books = lib_books,
                           all_authors = all_authors, all_categories = all_categories)

@manager_views.route('/lib<id>/manager/add_book',methods=['GET','POST'])
@library_exists
@manager_required
def add_book(id):
    if request.method=='POST':
        title = request.form.get('title')
        copies = request.form.get('copies')
        isbn = request.form.get('isbn')
        lang_id = request.form.get('lang_id')
        authors = request.form.get('authors')
        categories = request.form.get('categories')
        publisher = request.form.get('publisher')
        pages = request.form.get('pages')
        keywords = request.form.get('keywords')
        image = request.form.get('image')
        summary = request.form.get('summary')
        
        print(title, copies,isbn,lang_id,authors,categories,publisher, pages,keywords,image,summary)
        
        cur = mydb.connection.cursor()

        ### book title is unique for simplicity/normally i would replace it with book isbn
        cur.execute(f'''
            SELECT book_title.id FROM book_title
            WHERE title = '{title}'
        ''')
        title_id = cur.fetchone()

        # Book title doesn't exist!
        if(title_id == None):
            if (title==None or copies==None or isbn==None or lang_id==None or authors==None or categories==None
                or publisher==None or pages==None or keywords==None or image==None or summary==None):
                flash('This book title doesn\'t exist. Complete all form fields.', category='error')
                return render_template("manager_add_book.html", view='manager',id=id, book_exists = False) 
            else:
                cur.execute('''
                    INSERT INTO book_title (title, publisher, isbn, summary, image, lang_id, pages)
                    VALUES (%s, %s, %s, %s, %s, %s, %s);''',
                    (title, publisher, isbn, summary, image, lang_id, pages)
                )
                mydb.connection.commit()

                cur.execute(f'''
                    SELECT id FROM book_title 
                    WHERE book_title.title = '{title}'
                ''')
                bookid = cur.fetchone()
                
                for author in authors.split(','):
                    cur.execute(f'''
                    CALL revise_authors('{author}',{bookid[0]})
                 ''')
                mydb.connection.commit()

                for category in categories.split(','):
                     cur.execute(f'''
                     CALL revise_categories('{category}',{bookid[0]})
                 ''')
                mydb.connection.commit()
                
                for keyword in keywords.split(','):
                 cur.execute(f'''
                 CALL revise_keywords('{keyword}',{bookid[0]})''')  
                mydb.connection.commit() 
    
                cur.execute('''
                    INSERT INTO book_instance
                    (book_id, school_id, copies)
                    VALUES 
                    (%s, %s, %s); ''',
                    (bookid, id, copies)
                )  
                mydb.connection.commit()
                cur.close()

                flash('New book title and book instance added successfully!', category='success')
                return redirect(url_for('manager_views.books', id=id))
        # Book title already exists!
        else:
            cur.execute(f'''
                SELECT id FROM book_instance 
                WHERE school_id = {id} AND book_id = {title_id[0]}
            ''')
            copy_id = cur.fetchone()

            # Book instance doesn't exist
            if (copy_id==None):
                print(title_id[0], id, copies)
                cur.execute('''
                    INSERT INTO book_instance
                        (book_id, school_id, copies)
                    VALUES 
                        (%s, %s, %s); '''
                    ,(title_id[0], id, copies)
                )
                mydb.connection.commit()
                cur.close()

                flash('Book instances added to school\'s library successfully!', category='success')
                return redirect(url_for('manager_views.books', id=id))
            # Book instance already exists, just add the extra copies
            else:
                cur.execute('''
                    UPDATE book_instance
                    SET copies = copies+%s
                    WHERE id = %s; ''',
                    (copies, copy_id[0])
                )
                mydb.connection.commit()
                cur.close()

                flash('Book instance already exists in school\'s library. Updated number of copies successfully!', category='success')
                return redirect(url_for('manager_views.books', id=id))

    return render_template("manager_add_book.html", view='manager',id=id, book_exists = True)   

### preview views

@manager_views.route('/lib<id>/manager/book<bookid>',methods=['GET',"POST"])
@library_exists
@manager_required
def preview(id, bookid):
    cur = mydb.connection.cursor()

    cur.execute(f'''
        SELECT title, isbn, publisher, lang_id, pages, summary, image
        FROM book_title
        WHERE book_title.id = {bookid};
    ''')
    data = cur.fetchone()
    print(data)

    cur.execute(f'''
        SELECT author
        FROM authors INNER JOIN book_authors
        ON authors.id = book_authors.author_id
        WHERE book_authors.book_id = {bookid};
    ''' )
    authors = [row[0] for row in cur.fetchall()]
    print(authors)

    cur.execute(f'''
        SELECT category
        FROM categories INNER JOIN book_categories
        ON categories.id = book_categories.category_id
        WHERE book_categories.book_id = {bookid};
    ''' )
    # print(cur.fetchall())
    categories = [row[0] for row in cur.fetchall()]
    print(categories)

    cur.execute(f'''
        SELECT keyword FROM
                keywords INNER JOIN book_keywords
                ON keywords.id = book_keywords.keyword_id
                WHERE book_keywords.book_id = {bookid} ;
                ''')
    book_keywords = [row[0] for row in cur.fetchall()]

    cur.execute(f'''
        SELECT summary 
        FROM book_title
        WHERE book_title.id = {bookid};
    ''')
    summary = [row[0] for row in cur.fetchall()]
    
    cur.close()
    return render_template("manager_preview.html", view='manager', id=id,bookid=bookid, title = data[0],
                          isbn = data[1],publisher = data[2], lang_id = data[3], pages = data[4], summary = data[5], image = data[6],
                            authors=authors, categories=categories, book_keywords = book_keywords)

    

### members views

@manager_views.route('/lib<id>/manager/members', methods = ['GET', 'POST'])
@library_exists
@manager_required
def members(id):
    if request.method == 'POST':
        name = request.form.get('name')
        birth_date = request.form.get('birth_date')
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
                        (username, password, role, school_id, is_active, name, birth_date)
                    VALUES
                        ('{username}', '{password}', '{role}', {int(id)}, TRUE, '{name}', '{birth_date}');
                ''')
                mydb.connection.commit()
                cur.close()
                flash('Account created successfully.', category='success')
            except Exception as e:
                flash(str(e), category='error')
                print(str(e))

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT username, role, id
        FROM user
        WHERE school_id = {int(id)} AND is_active = FALSE
            AND (role = 'member-teacher' OR role = 'member-student');
    ''')
    inactive_members_rec = cur.fetchall()

    cur.execute(f'''
        SELECT username, role, id
        FROM user
        WHERE school_id = {int(id)} AND is_active = TRUE
            AND (role = 'member-teacher' OR role = 'member-student');
    ''')
    active_members_rec = cur.fetchall()
    cur.close()

    inactive_members = list()
    for row in inactive_members_rec:
        inactive_members.append({'username': row[0], 'role': row[1], 'id': row[2]})
    active_members = list()
    for row in active_members_rec:
        active_members.append({'username': row[0], 'role': row[1], 'id': row[2]})
   
    return render_template("manager_members.html", view='manager', id=id
                           , inactive_members=inactive_members
                           , active_members=active_members)

@manager_views.route('/lib<id>/manager/members/card<user_id>')
@library_exists
@manager_required
def print_card(id, user_id):
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id, username, role, school_id, name, birth_date
        FROM user
        WHERE id = {int(user_id)};
    ''')
    user_rec = cur.fetchall()[0]
    cur.close()

    user = {'id': user_rec[0], 'username': user_rec[1], 'role': user_rec[2], 'school_id': user_rec[3], 'name': user_rec[4], 'birth_date': user_rec[5]}
    return render_template("manager_members_card.html", view='manager', id=id, user=user)

@manager_views.route('/lib<id>/manager/members/switch_activation', methods=['POST'])
@library_exists
@manager_required
def switch_activation(id):
    record = json.loads(request.data)
    member_id = record['member_id']
    try:
        cur = mydb.connection.cursor()
        cur.execute(f'''
            UPDATE user
            SET is_active = NOT is_active
            WHERE id = {int(member_id)};
        ''')
        mydb.connection.commit()
        cur.close()
        flash('Activation status changed successfully.', category='success')
    except Exception as e:
        flash(str(e), category='error')
        print(str(e))

    return jsonify({})

@manager_views.route('/lib<id>/manager/members/delete_user', methods=['POST'])
@library_exists
@manager_required
def delete_user(id):
    record = json.loads(request.data)
    member_id = record['member_id']
    try:
        cur = mydb.connection.cursor()
        cur.execute(f'''
            DELETE FROM user
            WHERE id = {int(member_id)}; 
        ''')
        mydb.connection.commit()
        cur.close()
        flash('User deleted successfully.', category='success')
    except Exception as e:
        flash(str(e), category='error')
        print(str(e))

    return jsonify({})

### borrowings views

@manager_views.route('/lib<id>/manager/borrowings/')
@library_exists
@manager_required
def borrowings(id):
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username, user.id, borrowing.borrow_date
        FROM borrowing
        INNER JOIN book_title
        ON borrowing.book_id = book_title.id
        INNER JOIN user
        ON borrowing.user_id = user.id
        WHERE (user.role = 'member-student' OR user.role = 'member-teacher')
            AND user.school_id = {id} AND borrowing.status = 'active';
    ''')
    active_borrowings_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username,
            user.id, DATE_ADD(borrowing.borrow_date, INTERVAL 1 WEEK)
        FROM borrowing
        INNER JOIN book_title
        ON borrowing.book_id = book_title.id
        INNER JOIN user
        ON borrowing.user_id = user.id
        WHERE (user.role = 'member-student' OR user.role = 'member-teacher')
            AND user.school_id = {id} AND borrowing.status = 'delayed';
    ''')
    delayed_borrowings_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username, user.id, borrowing.return_date
        FROM borrowing
        INNER JOIN book_title
        ON borrowing.book_id = book_title.id
        INNER JOIN user
        ON borrowing.user_id = user.id
        WHERE (user.role = 'member-student' OR user.role = 'member-teacher')
            AND user.school_id = {id} AND borrowing.status = 'completed';
    ''')
    completed_borrowings_rec = cur.fetchall()
    
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username, user.id, reservation.reserve_date
        FROM reservation
        INNER JOIN book_title
        ON reservation.book_id = book_title.id
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE (user.role = 'member-student' OR user.role = 'member-teacher')
            AND user.school_id = {id} AND reservation.status = 'active';
    ''')
    active_reservations_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username, user.id, reservation.request_date
        FROM reservation
        INNER JOIN book_title
        ON reservation.book_id = book_title.id
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE (user.role = 'member-student' OR user.role = 'member-teacher')
            AND user.school_id = {id} AND reservation.status = 'pending';
    ''')
    pending_reservations_rec = cur.fetchall()
    cur.close()

    active_borrowings = list()
    for row in active_borrowings_rec:
        active_borrowings.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'id': row[3], 'date': row[4]})
    delayed_borrowings = list()
    for row in delayed_borrowings_rec:
        delayed_borrowings.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'id': row[3], 'date': row[4]})
    completed_borrowings = list()
    for row in completed_borrowings_rec:
        completed_borrowings.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'id': row[3], 'date': row[4]})
    active_reservations = list()
    for row in active_reservations_rec:
        active_reservations.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'id': row[3], 'date': row[4]})
    pending_reservations = list()
    for row in pending_reservations_rec:
        pending_reservations.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'id': row[3], 'date': row[4]})
    
    return render_template("manager_borrowings.html", view='manager', id=id, pending_reservations=pending_reservations
                           , active_reservations=active_reservations, delayed_borrowings=delayed_borrowings
                           , active_borrowings=active_borrowings, completed_borrowings=completed_borrowings)

@manager_views.route('/lib<id>/manager/borrowings/borrow_book', methods=['POST'])
@library_exists
@manager_required
def borrow_book(id):
    ##### taking book_title and member_username for simplicity in testing
    ##### change that to book_isbn and member_id
    member_username = request.form.get('user_username')
    book_title = request.form.get('book_title')

    # title is unique only for testing purposes
    # change that in the end
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id
        FROM book_title
        WHERE title = '{book_title}'; 
    ''')
    mydb.connection.commit()
    book_id = cur.fetchall()

    cur.execute(f'''
        SELECT id, role
        FROM user
        WHERE username = '{member_username}'
            AND (role = 'member-student' OR role = 'member-teacher');
    ''')
    mydb.connection.commit()
    member = cur.fetchall()
    cur.close()

    if not book_id:
        flash('No such book title.', category='error')
        return redirect(url_for('manager_views.borrowings', id=id))
    if not member:
        flash('No such member in this library.', category='error')
        return redirect(url_for('manager_views.borrowings', id=id))
    
    book_id = int(book_id[0][0])
    member_id = int(member[0][0])
    manager_id = int(session['id'])
    member_role = member[0][1]

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT *
        FROM borrowing
        WHERE user_id = {member_id} AND status = 'delayed';
    ''')
    mydb.connection.commit()
    delayed_borrowing = cur.fetchall()

    cur.execute(f'''
        SELECT *
        FROM borrowing
        WHERE user_id = {member_id} AND CURRENT_DATE() <= DATE_ADD(borrow_date, INTERVAL 1 WEEK);
    ''')
    mydb.connection.commit()
    last_week_borrowings = cur.fetchall()
    
    cur.execute(f'''
        SELECT *
        FROM book_instance
        WHERE book_id = {book_id} AND school_id = {id};
    ''')
    mydb.connection.commit()
    book_instance_exists = cur.fetchall()

    cur.execute(f'''
        SELECT *
        FROM borrowing
        WHERE user_id = {member_id} AND book_id = {book_id} AND (status = 'active' OR status = 'delayed');
    ''')
    mydb.connection.commit()
    same_book_borrowed = cur.fetchall()

    cur.execute(f'''
        SELECT *
        FROM reservation
        WHERE user_id = {member_id} AND book_id = {book_id} AND status = 'active';
    ''')
    mydb.connection.commit()
    book_reserved = cur.fetchall()

    cur.execute(f'''
        SELECT copies
        FROM book_instance
        INNER JOIN book_title
        ON book_title.id = book_instance.book_id
        WHERE book_instance.school_id = {id} AND book_title.id = {book_id};
    ''')
    mydb.connection.commit()
    book_copies = cur.fetchall()
    print(book_copies)

    cur.close()
    
    if delayed_borrowing:
        flash('Member has a delayed borrowing.', category='error')
    elif member_role == 'member-student' and len(last_week_borrowings) >= 2:
        flash('Member (student) has already borrowed two books this week.', category='error')
    elif member_role == 'member-teacher' and len(last_week_borrowings) >= 1:
        flash('Member (teacher) has already borrowed one book this week.', category='error')
    elif not book_instance_exists:
        flash('Book instance does not exist in the library.', category='error')
    elif same_book_borrowed:
        flash('Same book is already borrowed to member.', category='error')
    else:
        if book_reserved:
            cur = mydb.connection.cursor()
            # insert the new borrow
            cur.execute(f'''
                INSERT INTO borrowing
                    (user_id, book_id, manager_id, status, borrow_date)
                VALUES
                    ({member_id}, {book_id}, {manager_id}, 'active', CURRENT_DATE())
                ;
            ''')
            mydb.connection.commit()

            # make the reservation expired
            cur.execute(f'''
                UPDATE reservation
                SET status = 'expired'
                WHERE user_id = {member_id} AND book_id = {book_id} AND status = 'active';
            ''')
            mydb.connection.commit()
            cur.close()
            flash('Book was borrowed successfully (with reservation).', category='success')
        elif book_copies[0][0] > 0:
            cur = mydb.connection.cursor()
            # insert the new borrow
            cur.execute(f'''
                INSERT INTO borrowing
                    (user_id, book_id, manager_id, status, borrow_date)
                VALUES
                    ({member_id}, {book_id}, {manager_id}, 'active', CURRENT_DATE())
                ;
            ''')
            mydb.connection.commit()

            # subtract one copy
            cur.execute(f'''
                UPDATE book_instance
                SET copies = copies-1
                WHERE book_id = {book_id} AND school_id = {id};
            ''')
            mydb.connection.commit()
            cur.close()
            flash('Book was borrowed successfully (no reservation).', category='success')
        else:
            flash('There is no active reservation and no availability for the book.', category='error')

    return redirect(url_for('manager_views.borrowings', id=id))

@manager_views.route('/lib<id>/manager/borrowings/return_book', methods=['POST'])
@library_exists
@manager_required
def return_book(id):
    ##### taking book_title and member_username for simplicity in testing
    ##### change that to book_isbn and member_id
    member_username = request.form.get('user_username')
    book_title = request.form.get('book_title')

    # title is unique only for testing purposes
    # change that in the end
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id
        FROM book_title
        WHERE title = '{book_title}'; 
    ''')
    mydb.connection.commit()
    book_id = cur.fetchall()

    cur.execute(f'''
        SELECT id
        FROM user
        WHERE username = '{member_username}' AND school_id = {id}
            AND (role = 'member-student' OR role = 'member-teacher');
    ''')
    mydb.connection.commit()
    member_id = cur.fetchall()
    cur.close()

    if not book_id:
        flash('No such book title.', category='error')
        return redirect(url_for('manager_views.borrowings', id=id))
    if not member_id:
        flash('No such member in this library.', category='error')
        return redirect(url_for('manager_views.borrowings', id=id))
    
    book_id = int(book_id[0][0])
    member_id = int(member_id[0][0])

    print(book_id, member_id)

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id
        FROM borrowing
        WHERE user_id = {member_id} AND book_id = {book_id} AND (status = 'active' OR status = 'delayed');
    ''')
    mydb.connection.commit()
    borrowing_exists = cur.fetchall()
    cur.close()


    if not borrowing_exists:
        flash('No such active/delayed borrowing exists.', category='error')
    else:
        cur = mydb.connection.cursor()
        # mark the borrow as 'completed'
        cur.execute(f'''
            UPDATE borrowing
            SET status = 'completed', return_date = CURRENT_DATE()
            WHERE user_id = {member_id} AND book_id = {book_id} AND (status = 'active' OR status = 'delayed');
        ''')
        mydb.connection.commit()

        # add one copy
        cur.execute(f'''
            UPDATE book_instance
            SET copies = copies+1
            WHERE book_id = {book_id} AND school_id = {id};
        ''')
        mydb.connection.commit()
        cur.close()
        flash('Return action completed successfully.', category='success')
        return redirect(url_for('manager_views.borrowings', id=id))
    return redirect(url_for('manager_views.borrowings', id=id))

### reviews views

@manager_views.route('/lib<id>/manager/reviews')
@library_exists
@manager_required
def reviews(id):
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username, user.id, review.stars, review.opinion, review.id
        FROM review
        INNER JOIN book_title
        ON review.book_id = book_title.id
        INNER JOIN user
        ON review.user_id = user.id
        WHERE review.is_active = FALSE;
    ''')
    inactive_reviews_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, user.username, user.id, review.stars, review.opinion, review.id
        FROM review
        INNER JOIN book_title
        ON review.book_id = book_title.id
        INNER JOIN user
        ON review.user_id = user.id
        WHERE review.is_active = TRUE;
    ''')
    active_reviews_rec = cur.fetchall()
    cur.close()

    inactive_reviews = list()
    for row in inactive_reviews_rec:
        inactive_reviews.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'user_id': row[3], 'stars': row[4], 'opinion': row[5], 'id': row[6]})
    active_reviews = list()
    for row in active_reviews_rec:
        active_reviews.append({'title': row[0], 'isbn': row[1], 'username': row[2], 'user_id': row[3], 'stars': row[4], 'opinion': row[5], 'id': row[6]})

    return render_template("manager_reviews.html", view='member', id=id
                           , inactive_reviews=inactive_reviews
                           , active_reviews=active_reviews)

@manager_views.route('/lib<id>/manager/reviews/switch_activation', methods=['POST'])
@library_exists
@manager_required
def switch_activation_review(id):
    print("inside switch activation review")
    record = json.loads(request.data)
    review_id = record['review_id']
    try:
        cur = mydb.connection.cursor()
        cur.execute(f'''
            UPDATE review
            SET is_active = NOT is_active
            WHERE id = {int(review_id)};
        ''')
        mydb.connection.commit()
        cur.close()
        flash('Activation status changed successfully.', category='success')
    except Exception as e:
        flash(str(e), category='error')
        print(str(e))

    return jsonify({})

@manager_views.route('/lib<id>/manager/reviews/delete_review', methods=['POST'])
@library_exists
@manager_required
def delete_review(id):
    record = json.loads(request.data)
    review_id = record['review_id']
    try:
        cur = mydb.connection.cursor()
        cur.execute(f'''
            DELETE FROM review
            WHERE id = {int(review_id)}; 
        ''')
        mydb.connection.commit()
        cur.close()
        flash('Review deleted successfully.', category='success')
    except Exception as e:
        flash(str(e), category='error')
        print(str(e))

    return jsonify({})

### settings views

@manager_views.route('/lib<id>/manager/settings')
@library_exists
@manager_required
def settings(id):
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT name, birth_date
        FROM user
        WHERE id = {int(session['id'])};
    ''')
    user_rec = cur.fetchall()
    cur.close()

    user = {'name': user_rec[0][0], 'birth_date': str(user_rec[0][1])}
    return render_template("manager_settings.html", view='manager', id=id, user=user)

@manager_views.route('/lib<id>/manager/settings/change_info', methods = ['POST'])
@library_exists
@manager_required
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

    return redirect(url_for('manager_views.settings', id=id))

@manager_views.route('/lib<id>/manager/settings/change_password', methods = ['POST'])
@library_exists
@manager_required
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

    return redirect(url_for('manager_views.settings', id=id))



@manager_views.route('/lib<id>/manager/book<bookid>/book_edit', methods = ['GET', 'POST'])
@library_exists
@manager_required
def edit_details(id, bookid):
    cur = mydb.connection.cursor()

    cur.execute(f'''
        SELECT title, isbn, publisher, lang_id, pages, summary, image
        FROM book_title
        WHERE book_title.id = {bookid};
    ''')
    data = cur.fetchone()
    #print(data)

    cur.execute(f'''
        SELECT author
        FROM authors INNER JOIN book_authors
        ON authors.id = book_authors.author_id
        WHERE book_authors.book_id = {bookid};
    ''' )
    authors = [row[0] for row in cur.fetchall()]
    #print(authors)

    cur.execute(f'''
        SELECT category
        FROM categories INNER JOIN book_categories
        ON categories.id = book_categories.category_id
        WHERE book_categories.book_id = {bookid};
    ''' )
    # print(cur.fetchall())
    categories = [row[0] for row in cur.fetchall()]
    #print(categories)

    cur.execute(f'''
        SELECT keyword FROM
                keywords INNER JOIN book_keywords
                ON keywords.id = book_keywords.keyword_id
                WHERE book_keywords.book_id = {bookid} ;
                ''')
    book_keywords = [row[0] for row in cur.fetchall()]

    title = data[0]
    isbn = data[1]
    publisher = data [2]
    lang_id = data[3]
    pages=data[4]
    summary = data[5]
    image = data[6]

    if request.method == 'POST':
        new_lang  = request.form.get('edit_langid')
        new_publisher = request.form.get('edit_publisher')
        new_categories= request.form.get('edit_category')
        new_authors= request.form.get('edit_authors')
        new_keywords = request.form.get('edit_keys')
        new_summary = request.form.get('edit_summary')
        new_pages = request.form.get('edit_pages')

        #print(int(pages)==data[4])
        #print(len(new_keywords))

        changes = False

        cur = mydb.connection.cursor()

        if new_lang != lang_id :
            changes = True
            cur.execute('''
            UPDATE book_title
            SET lang_id = %s
            WHERE id = %s ; ''',
            (new_lang, bookid[0]))
            mydb.connection.commit()
            lang_id = new_lang

        if new_publisher != publisher:
            changes = True
            cur.execute('''
            UPDATE book_title
            SET lang_id = %s
            WHERE id = %s ; ''',
            (new_lang, bookid[0]))
            mydb.connection.commit()
            publisher = new_publisher

        # remove existing categories for safety to avoid duplicates and add them again if specified
        if new_categories != None and len(new_categories) > 0 :
            changes = True
            cur.execute('''
            DELETE FROM book_categories
            WHERE book_id = %s ; ''', (bookid)) 
            mydb.connection.commit() 

            for category in new_categories.split(','):
                cur.execute(f'''
                CALL revise_categories('{category}',{bookid});
                 ''')
                mydb.connection.commit()
            categories = list(new_categories.split(','))

        if new_authors != None and len(new_authors) > 0 :
            changes = True
            cur.execute('''
            DELETE FROM book_authors
            WHERE book_id = %s ; ''', (bookid)) 
            mydb.connection.commit()

            for author in new_authors.split(',') :
                cur.execute(f'''
                CALL revise_authors('{author}',{bookid});
                ''')
                mydb.connection.commit()
            authors = list(new_authors.split(','))

        if new_keywords != None and len(new_keywords) > 0 : 
            changes = True
            cur.execute('''
            DELETE FROM book_keywords
            WHERE book_id = %s ; ''', (bookid)) 
            mydb.connection.commit() 

            for keyword in new_keywords.split(','):
                cur.execute(f'''
                CALL revise_keywords('{keyword}',{bookid}) ;''') 
                mydb.connection.commit()

            book_keywords = list(new_keywords.split(','))

        if new_summary!= summary:
            changes = True
            cur.execute('''
            UPDATE book_title 
            SET summary = %s
            WHERE id = %s ;''',
            (new_summary, bookid) )
            mydb.connection.commit()

            summary = new_summary

        if int(new_pages) != pages :
            changes = True
            cur.execute('''
            UPDATE book_title
            SET pages = %s
            WHERE id = %s ; ''',
            (new_pages, bookid))
            mydb.connection.commit()
            pages = new_pages
        
        if changes:
            flash('Book-detail changes were submitted successfully.', category='success')
        else: 
             flash('No changes made.', category='info')

        cur.close()
        return render_template("manager_preview.html", view='manager', id=id, bookid=bookid, title = title,
                          isbn = isbn, publisher = publisher, lang_id = lang_id, pages = pages, summary = summary, image = image,
                            authors=authors, categories=categories, book_keywords = book_keywords)

    
    cur.close()
    return render_template("manager_book_edit.html", view='manager', id=id,bookid=bookid, title = title,
                          isbn = isbn ,publisher = publisher, lang_id = lang_id, pages = pages, summary = summary, image = image,
                            authors=authors, categories=categories, book_keywords = book_keywords)