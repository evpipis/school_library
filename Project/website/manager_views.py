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
    if request.method=='POST':
        print("inside POST request")
        cur = mydb.connection.cursor()
        cur.execute(f'''
            SELECT name 
            FROM school_unit
            WHERE id = {id};
        ''')
        schoolname = cur.fetchone()

        filter = request.form.get('filter')
        keyword = request.form.get('search_book')
        print(filter)
        print(keyword)

        if (filter == 'title'):
            cur.execute (f'''
                SELECT title, copies, book_instance.id
                FROM book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
                WHERE book_instance.school_id = {id} AND book_title.title = '{keyword}';
            ''')
        if (filter == 'category'):
            cur.execute (f'''
                SELECT BT1.title, BI1.copies, BT1.id
                FROM book_title AS BT1 INNER JOIN book_instance AS BI1 ON BT1.id = BI1.book_id 
                INNER JOIN book_categories AS BC ON BC.book_id = BI1.book_id
                INNER JOIN categories AS C ON C.id = BC.category_id
                WHERE BI1.school_id = {id} AND C.category = '{keyword}';
            ''')
        if (filter == 'author'):
            cur.execute(f'''
                SELECT BT1.title, BI1.copies, BT1.id
                FROM book_title AS BT1 INNER JOIN book_instance AS BI1 ON BT1.id = BI1.book_id 
                INNER JOIN book_authors AS BA ON BA.book_id = BI1.book_id
                INNER JOIN authors AS A ON A.id = BA.author_id
                WHERE BI1.school_id = {id} AND A.author = '{keyword}';
            ''')

        selected_books = cur.fetchall()
        cur.close()

        print("cursor_closed")
        print(selected_books)
        if (selected_books!= ()):
            flash('Books search was successful.')
            return render_template("manager_books.html", view='manager', id=id, schoolname = schoolname[0], lib_books = selected_books)
        else:
            flash('Books not Found.', category='error')
    
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT name 
        FROM school_unit
        WHERE id = {id};
    ''')
    schoolname = cur.fetchone()

    cur.execute(f'''
        SELECT title, copies, book_instance.id
        FROM book_title INNER JOIN book_instance
        ON book_title.id = book_instance.book_id
        WHERE book_instance.school_id = {id};
    ''')
    lib_books = cur.fetchall()
    cur.close()
    return render_template("manager_books.html", view='manager', id=id, schoolname = schoolname[0], lib_books = lib_books)

### preview views

@manager_views.route('/lib<id>/manager/book<bookid>',methods=['GET',"POST"])
@library_exists
@manager_required
def preview(id, bookid):
    cur = mydb.connection.cursor()

    cur.execute(f'''
        SELECT title 
        FROM book_title
        WHERE book_title.id = {bookid};
    ''')
    title = cur.fetchone()

    cur.execute(f'''
        SELECT isbn 
        FROM book_title
        WHERE book_title.id = {bookid};
    ''')
    isbn = cur.fetchone()

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
        SELECT summary 
        FROM book_title
        WHERE book_title.id = {bookid};
    ''')
    summary = [row[0] for row in cur.fetchall()]
    
    cur.close()
    return render_template("manager_preview.html", view='manager', id=id
                           , bookid=bookid ,title=title[0], isbn=isbn[0]
                           , authors=authors, categories=categories, summary=summary[0])

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
    return render_template("manager_reviews.html", view='manager', id=id)

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