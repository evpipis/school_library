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

### books views

@member_views.route('/lib<id>/member', methods = ['GET', 'POST'])
@member_views.route('/lib<id>/member/books', methods = ['GET', 'POST'])
@library_exists
@member_required
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

        print(filter_author)
        print(filter_category)
        print(filter_title)
        selected_books=()

        # assuming title is unique it overwrites other filters...
        if filter_title != None :
            cur.execute(f'''
                        CALL filter_title ({id},'{filter_title}');
                        ''')
            selected_books = cur.fetchall()

        else:
            
            if filter_author != 'all_books' :
                cur.execute(f'''
                            CALL filter_author({id},'{filter_author}');''')
                selected_books = set(cur.fetchall())

                if filter_category != 'all_books' :
                    cur.execute(f'''
                                CALL filter_category({id},'{filter_category}');''')
                    selected_books = selected_books.intersection(cur.fetchall())
            else:
                if filter_category != 'all_books' :
                    cur.execute(f'''
                    CALL filter_category({id},'{filter_category}');''')
                    selected_books = cur.fetchall()


        cur.close()

        print("cursor_closed")
        print(selected_books)
        if (selected_books!= () and selected_books!=set()):
            return render_template("member_books.html", view='member', id=id, schoolname=schoolname[0], lib_books = selected_books,
                                   all_authors = all_authors, all_categories = all_categories)
        else:
            flash('Books not Found!', category='error')

    cur.close()
    return render_template("member_books.html", view='member', id=id, schoolname = schoolname[0], lib_books = lib_books,
                           all_authors = all_authors, all_categories = all_categories)



### preview views

@member_views.route('/lib<id>/member/book<bookid>',methods=['GET'])
@library_exists
@member_required
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
    return render_template("member_preview.html", view='member', id=id,bookid=bookid, title = data[0],
                          isbn = data[1],publisher = data[2], lang_id = data[3], pages = data[4], summary = data[5], image = data[6],
                            authors=authors, categories=categories, book_keywords = book_keywords)

@member_views.route('/lib<id>/member/book<bookid>/make_review',methods=['POST'])
@library_exists
@member_required
def make_review(id, bookid):
    print('inside review with id, book_id;', bookid)
    stars = request.form.get('stars')
    review_text = request.form.get('reviewText')

    cur = mydb.connection.cursor()

    user_id = session.get('id')
    approved = not(session.get('role') == 'member-student')
    
    cur.execute(f'''
        SELECT *
        FROM review
        WHERE user_id = {user_id} AND book_id = {bookid};
    ''')
    
    mydb.connection.commit()
    record = cur.fetchall()
    cur.close()

    if record:
        flash('Member has already submitted review for this book!', category='error')
        return redirect(url_for('member_views.preview', id=id, bookid=bookid))

    cur = mydb.connection.cursor()
    cur.execute('''
        INSERT INTO review (user_id , book_id, opinion, stars, is_active)
        VALUES (%s, %s, %s, %s, %s);''', 
        (user_id, bookid, review_text, stars, approved)
    )
    mydb.connection.commit()
    cur.close()
    flash('Your review was submitted successfully!', category='success')
    return redirect(url_for('member_views.preview', id=id, bookid=bookid))

@member_views.route('/lib<id>/member/book<bookid>/reserve_book', methods = ['POST'])
@library_exists
@member_required
def reserve_book_button(id, bookid):
    print("inside here!!!!")
    ##### taking book_title and member_username for simplicity in testing
    ##### change that to book_isbn and member_id
    book_id = int(bookid)
    member_id = int(session['id'])
    member_role = session['role']

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
        FROM reservation
        WHERE user_id = {member_id} AND CURRENT_DATE() <= DATE_ADD(request_date, INTERVAL 1 WEEK);
    ''')
    mydb.connection.commit()
    last_week_reservations = cur.fetchall()
    
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
        WHERE user_id = {member_id} AND book_id = {book_id} AND (status = 'active' OR status = 'pending');
    ''')
    mydb.connection.commit()
    same_book_reserved = cur.fetchall()

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
    elif member_role == 'member-student' and len(last_week_reservations) >= 2:
        flash('Member (student) has already requested/reserved two books this week.', category='error')
    elif member_role == 'member-teacher' and len(last_week_reservations) >= 1:
        flash('Member (teacher) has already requested/reserved one book this week.', category='error')
    elif not book_instance_exists:
        flash('Book instance does not exist in the library.', category='error')
    elif same_book_borrowed:
        flash('Same book is already borrowed to member.', category='error')
    elif same_book_reserved:
        flash('Same book is already requested/reserved to member.', category='error')
    else:
        # there are currently no book copies available
        if book_copies[0][0] == 0:
            cur = mydb.connection.cursor()
            # insert the new reservation with pending status
            cur.execute(f'''
                INSERT INTO reservation
                    (user_id, book_id, status, request_date, reserve_date)
                VALUES
                    ({member_id}, {book_id}, 'pending', CURRENT_DATE(), NULL)
                ;
            ''')
            mydb.connection.commit()
            cur.close()
            flash('Book reservation was requested successfully. Your reservation will be activated when there will be availability.', category='success')
        # there is currently availability
        else:
            cur = mydb.connection.cursor()
            # subtract one copy
            cur.execute(f'''
                UPDATE book_instance
                SET copies = copies-1
                WHERE book_id = {book_id} AND school_id = {id};
            ''')
            mydb.connection.commit()
            
            # insert the new borrow
            cur.execute(f'''
                INSERT INTO reservation
                    (user_id, book_id, status, request_date, reserve_date)
                VALUES
                    ({member_id}, {book_id}, 'active', CURRENT_DATE(), CURRENT_DATE())
                ;
            ''')
            mydb.connection.commit()
            cur.close()
            flash('Book was reserved successfully.', category='success')

    return redirect(url_for('member_views.preview', id=id, bookid=bookid))

### my_borrowings views

@member_views.route('/lib<id>/member/my_borrowings')
@library_exists
@member_required
def my_borrowings(id):
    user_id = int(session['id'])
    user_username = session['username']
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, borrowing.borrow_date
        FROM borrowing
        INNER JOIN book_title
        ON borrowing.book_id = book_title.id
        WHERE borrowing.user_id = {user_id} AND borrowing.status = 'active';
    ''')
    active_borrowings_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, DATE_ADD(borrowing.borrow_date, INTERVAL 1 WEEK)
        FROM borrowing
        INNER JOIN book_title
        ON borrowing.book_id = book_title.id
        WHERE borrowing.user_id = {user_id} AND borrowing.status = 'delayed';
    ''')
    delayed_borrowings_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, borrowing.return_date
        FROM borrowing
        INNER JOIN book_title
        ON borrowing.book_id = book_title.id
        WHERE borrowing.user_id = {user_id} AND borrowing.status = 'completed';
    ''')
    completed_borrowings_rec = cur.fetchall()
    
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, reservation.reserve_date
        FROM reservation
        INNER JOIN book_title
        ON reservation.book_id = book_title.id
        WHERE reservation.user_id = {user_id} AND reservation.status = 'active';
    ''')
    active_reservations_rec = cur.fetchall()

    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, reservation.request_date
        FROM reservation
        INNER JOIN book_title
        ON reservation.book_id = book_title.id
        WHERE reservation.user_id = {user_id} AND reservation.status = 'pending';
    ''')
    pending_reservations_rec = cur.fetchall()
    cur.close()

    active_borrowings = list()
    for row in active_borrowings_rec:
        active_borrowings.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'id': user_id, 'date': row[2]})
    delayed_borrowings = list()
    for row in delayed_borrowings_rec:
        delayed_borrowings.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'id': user_id, 'date': row[2]})
    completed_borrowings = list()
    for row in completed_borrowings_rec:
        completed_borrowings.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'id': user_id, 'date': row[2]})
    active_reservations = list()
    for row in active_reservations_rec:
        active_reservations.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'id': user_id, 'date': row[2]})
    pending_reservations = list()
    for row in pending_reservations_rec:
        pending_reservations.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'id': user_id, 'date': row[2]})
    
    return render_template("member_my_borrowings.html", view='member', id=id, pending_reservations=pending_reservations
                           , active_reservations=active_reservations, delayed_borrowings=delayed_borrowings
                           , active_borrowings=active_borrowings, completed_borrowings=completed_borrowings)

@member_views.route('/lib<id>/member/my_borrowings/reserve_book', methods = ['POST'])
@library_exists
@member_required
def reserve_book(id):
    ##### taking book_title and member_username for simplicity in testing
    ##### change that to book_isbn and member_id
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
    cur.close()

    if not book_id:
        flash('No such book title.', category='error')
        return redirect(url_for('member_views.my_borrowings', id=id))
    book_id = int(book_id[0][0])
    member_id = int(session['id'])
    member_role = session['role']

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
        FROM reservation
        WHERE user_id = {member_id} AND CURRENT_DATE() <= DATE_ADD(request_date, INTERVAL 1 WEEK);
    ''')
    mydb.connection.commit()
    last_week_reservations = cur.fetchall()
    
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
        WHERE user_id = {member_id} AND book_id = {book_id} AND (status = 'active' OR status = 'pending');
    ''')
    mydb.connection.commit()
    same_book_reserved = cur.fetchall()

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
    elif member_role == 'member-student' and len(last_week_reservations) >= 2:
        flash('Member (student) has already requested/reserved two books this week.', category='error')
    elif member_role == 'member-teacher' and len(last_week_reservations) >= 1:
        flash('Member (teacher) has already requested/reserved one book this week.', category='error')
    elif not book_instance_exists:
        flash('Book instance does not exist in the library.', category='error')
    elif same_book_borrowed:
        flash('Same book is already borrowed to member.', category='error')
    elif same_book_reserved:
        flash('Same book is already requested/reserved to member.', category='error')
    else:
        # there are currently no book copies available
        if book_copies[0][0] == 0:
            cur = mydb.connection.cursor()
            # insert the new reservation with pending status
            cur.execute(f'''
                INSERT INTO reservation
                    (user_id, book_id, status, request_date, reserve_date)
                VALUES
                    ({member_id}, {book_id}, 'pending', CURRENT_DATE(), NULL)
                ;
            ''')
            mydb.connection.commit()
            cur.close()
            flash('Book reservation was requested successfully. Your reservation will be activated when there will be availability.', category='success')
        # there is currently availability
        else:
            cur = mydb.connection.cursor()
            # subtract one copy
            cur.execute(f'''
                UPDATE book_instance
                SET copies = copies-1
                WHERE book_id = {book_id} AND school_id = {id};
            ''')
            mydb.connection.commit()
            
            # insert the new borrow
            cur.execute(f'''
                INSERT INTO reservation
                    (user_id, book_id, status, request_date, reserve_date)
                VALUES
                    ({member_id}, {book_id}, 'active', CURRENT_DATE(), CURRENT_DATE())
                ;
            ''')
            mydb.connection.commit()
            cur.close()
            flash('Book was reserved successfully.', category='success')

    return redirect(url_for('member_views.my_borrowings', id=id))

@member_views.route('/lib<id>/member/my_borrowings/cancel_book', methods = ['POST'])
@library_exists
@member_required
def cancel_book(id):
    ##### taking book_title and member_username for simplicity in testing
    ##### change that to book_isbn and member_id
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
    cur.close()

    if not book_id:
        flash('No such book title.', category='error')
        return redirect(url_for('member_views.my_borrowings', id=id))
    book_id = int(book_id[0][0])
    member_id = int(session['id'])
    
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id
        FROM reservation
        WHERE user_id = {member_id} AND book_id = {book_id} AND status = 'active';
    ''')
    mydb.connection.commit()
    active_reservation_exists = cur.fetchall()

    cur.execute(f'''
        SELECT id
        FROM reservation
        WHERE user_id = {member_id} AND book_id = {book_id} AND status = 'pending';
    ''')
    mydb.connection.commit()
    pending_reservation_exists = cur.fetchall()
    cur.close()


    if not active_reservation_exists and not pending_reservation_exists:
        flash('No such active/pending reservation exists.', category='error')
    elif active_reservation_exists:
        cur = mydb.connection.cursor()
        # mark the reservation as 'expired'
        cur.execute(f'''
            UPDATE reservation
            SET status = 'expired'
            WHERE user_id = {member_id} AND book_id = {book_id} AND status = 'active';
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
        flash('Active reservation cancelled successfully.', category='success')
        return redirect(url_for('member_views.my_borrowings', id=id))
    else:
        cur = mydb.connection.cursor()
        # mark the reservation as 'expired'
        cur.execute(f'''
            UPDATE reservation
            SET status = 'expired'
            WHERE user_id = {member_id} AND book_id = {book_id} AND status = 'active';
        ''')
        mydb.connection.commit()
        cur.close()
        flash('Pending reservation cancelled successfully.', category='success')
        return redirect(url_for('member_views.my_borrowings', id=id))
    return redirect(url_for('member_views.my_borrowings', id=id))

@member_views.route('/lib<id>/member/my_reviews')
@library_exists
@member_required
def my_reviews(id):
    user_id = int(session['id'])
    user_username = session['username']
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, review.stars, review.opinion
        FROM review
        INNER JOIN book_title
        ON review.book_id = book_title.id
        WHERE review.user_id = {user_id} AND review.is_active = FALSE;
    ''')
    my_inactive_reviews_rec = cur.fetchall()

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, review.stars, review.opinion
        FROM review
        INNER JOIN book_title
        ON review.book_id = book_title.id
        WHERE review.user_id = {user_id} AND review.is_active = TRUE;
    ''')
    my_active_reviews_rec = cur.fetchall()

    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT book_title.title, book_title.isbn, review.stars, review.opinion
        FROM review
        INNER JOIN book_title
        ON review.book_id = book_title.id
        WHERE review.is_active = TRUE;
    ''')
    active_reviews_rec = cur.fetchall()
    cur.close()

    my_inactive_reviews = list()
    for row in my_inactive_reviews_rec:
        my_inactive_reviews.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'user_id': user_id, 'stars': row[2], 'opinion': row[3]})
    my_active_reviews = list()
    for row in my_active_reviews_rec:
        my_active_reviews.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'user_id': user_id, 'stars': row[2], 'opinion': row[3]})
    active_reviews = list()
    for row in active_reviews_rec:
        active_reviews.append({'title': row[0], 'isbn': row[1], 'username': user_username, 'user_id': user_id, 'stars': row[2], 'opinion': row[3]})
    

    return render_template("member_my_reviews.html", view='member', id=id
                           , my_inactive_reviews=my_inactive_reviews
                           , my_active_reviews=my_active_reviews
                           , active_reviews=active_reviews)

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