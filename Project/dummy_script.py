from flask import Flask,render_template, request
from flask_mysqldb import MySQL
import random
from datetime import date, timedelta

app = Flask(__name__)
 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'gatakia22'
app.config['MYSQL_DB'] = 'SchoolLibrary'
# secret_key = 'some random string'
 
mydb = MySQL(app)

if __name__ == '__main__': # needed so that the app does not run when imported
    app.run(debug=True, host='localhost', port=5000) # debug needed for reruning the server when we make code changes

@app.route('/')
def index():
    print(insert_dummy_data())
    return 'First page!'

def daterange(start_date, end_date):
    for n in range(int((end_date - start_date).days)):
        yield start_date + timedelta(n)

def insert_dummy_data():
    global mydb
    start_date = date(2023, 1, 1)
    end_date = date(2023, 6, 2) # today
    for single_date in daterange(start_date, end_date):
        cur_date = str(single_date.strftime("%Y-%m-%d"))
        print(cur_date)
        
        # daily update of delayed borrowings and expired reservations
        cur = mydb.connection.cursor()
        cur.execute(f'''
            UPDATE borrowing
            SET borrowing.status = 'delayed'
            WHERE borrowing.status = 'active' AND '{cur_date}' > DATE_ADD(borrowing.borrow_date, INTERVAL 1 WEEK);
        ''')
        cur.execute(f'''
            UPDATE reservation
            SET reservation.status = 'expired'
            WHERE (reservation.status = 'pending' AND '{cur_date}' > DATE_ADD(reservation.request_date, INTERVAL 1 WEEK));
        ''')
        cur.execute(f'''
            UPDATE reservation, book_instance
            SET reservation.status = 'expired', book_instance.copies = book_instance.copies+1
            WHERE (reservation.status = 'active' AND '{cur_date}' > DATE_ADD(reservation.reserve_date, INTERVAL 1 WEEK));
        ''')
        mydb.connection.commit()
        cur.close()

        # borrow and return books
        cur = mydb.connection.cursor()
        cur.execute(f'''
            SELECT *
            FROM school_unit; 
        ''')
        mydb.connection.commit()
        schools_num = len(cur.fetchall())

        cur.execute(f'''
            SELECT *
            FROM book_title; 
        ''')
        mydb.connection.commit()
        # books_num = len(cur.fetchall())
        cur.close()

        # try borrow 2 books per day
        for po in range(2):
            # school_id = random.randint(1, schools_num)

            cur = mydb.connection.cursor()
            cur.execute(f'''
                SELECT book_instance.school_id, book_instance.book_id, member.id, manager.id
                FROM book_instance
                INNER JOIN user as member
                ON member.school_id = book_instance.school_id
                INNER JOIN user as manager
                ON manager.school_id = book_instance.school_id
                WHERE manager.role = 'manager' AND (member.role = 'member-student' OR member.role = 'member-teacher')
            ''')
            mydb.connection.commit()
            record = cur.fetchall()
            cur.close()

            length = len(record)
            row = record[random.randint(0, length-1)]
            book_id = row[1]
            member_id = row[2]
            manager_id = row[3]

            if can_borrow(book_id, member_id, manager_id, cur_date):
                print(f"Success: borrow({book_id, member_id, manager_id, cur_date})")
            else:
                print(f"Error: borrow({book_id, member_id, manager_id, cur_date})")
        
        # return one book per day
        for po in range(1):
            if random.randint(0, 1) == 0:
                continue
            school_id = random.randint(1, schools_num)

            cur = mydb.connection.cursor()
            cur.execute(f'''
                SELECT book_id, user_id
                FROM borrowing
            ''')
            mydb.connection.commit()
            record = cur.fetchall()
            cur.close()

            length = len(record)
            row = record[random.randint(0, length-1)]
            book_id = row[0]
            member_id = row[1]

            if can_return(book_id, member_id, cur_date):
                print(f"Success: return({book_id, member_id, cur_date})")
            else:
                print(f"Error: return({book_id, member_id, cur_date})")
    return True


# cur_date is of the form '2022-02-15'
def can_borrow(book_id, member_id, manager_id, cur_date):
    # check that member_id and manager_id are from the same school and there is a book_title with book_id
    # also taking the school_id and member_role
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id
        FROM book_title
        WHERE id = '{book_id}'; 
    ''')
    mydb.connection.commit()
    book_title_exists = cur.fetchall()

    # is_active field should be independent from the borrows reservation
    # the only thing that does is activates or deactivates the accounts
    # so that the users can at this time use their account and operations
    # it doesn't matter if in the past there were some borrowings or reservations
    # from an inactive account, they remain but it is shown nowhere
    cur.execute(f'''
        SELECT school_unit.id, member.role
        FROM school_unit
        INNER JOIN user as member
        ON member.school_id = school_unit.id
        INNER JOIN user as manager
        ON manager.school_id = school_unit.id
        WHERE manager.role = 'manager' AND (member.role = 'member-student' OR member.role = 'member-teacher')
                AND manager.id = {manager_id} AND member.id = {member_id};
    ''')
    mydb.connection.commit()
    common_school = cur.fetchall()
    cur.close()

    if not book_title_exists:
        print('No such book title.')
        return False
    if not common_school:
        print('There is no school with this member, manager.')
        return False
    id = common_school[0][0]
    member_role = common_school[0][1]    

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
        WHERE user_id = {member_id} AND '{cur_date}' <= DATE_ADD(borrow_date, INTERVAL 1 WEEK);
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

    cur.close()
    
    if delayed_borrowing:
        print('Member has a delayed borrowing.')
    elif member_role == 'member-student' and len(last_week_borrowings) >= 2:
        print('Member (student) has already borrowed two books this week.')
    elif member_role == 'member-teacher' and len(last_week_borrowings) >= 1:
        print('Member (teacher) has already borrowed one book this week.')
    elif not book_instance_exists:
        print('Book instance does not exist in the library.')
    elif same_book_borrowed:
        print('Same book is already borrowed to member.')
    else:
        if book_reserved:
            cur = mydb.connection.cursor()
            # insert the new borrow
            cur.execute(f'''
                INSERT INTO borrowing
                    (user_id, book_id, manager_id, status, borrow_date)
                VALUES
                    ({member_id}, {book_id}, {manager_id}, 'active', '{cur_date}')
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
            print('Book was borrowed successfully (with reservation).')
            return True
        elif book_copies[0][0] > 0:
            cur = mydb.connection.cursor()
            # insert the new borrow
            cur.execute(f'''
                INSERT INTO borrowing
                    (user_id, book_id, manager_id, status, borrow_date)
                VALUES
                    ({member_id}, {book_id}, {manager_id}, 'active', '{cur_date}')
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
            print('Book was borrowed successfully (no reservation).')
            return True
        else:
            print('There is no active reservation and no availability for the book.')

    return False


def can_return(book_id, member_id, cur_date):
    cur = mydb.connection.cursor()
    cur.execute(f'''
        SELECT id
        FROM borrowing
        WHERE user_id = {member_id} AND book_id = {book_id} AND (status = 'active' OR status = 'delayed');
    ''')
    mydb.connection.commit()
    borrowing_exists = cur.fetchall()

    cur.execute(f'''
        SELECT school_id
        FROM user
        WHERE id = {member_id};
    ''')
    mydb.connection.commit()
    id = cur.fetchall()[0][0]
    cur.close()


    if not borrowing_exists:
        print('No such active/delayed borrowing exists.')
    else:
        cur = mydb.connection.cursor()
        # mark the borrow as 'completed'
        cur.execute(f'''
            UPDATE borrowing
            SET status = 'completed', return_date = '{cur_date}'
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
        print('Return action completed successfully.')
        return True
    return False

