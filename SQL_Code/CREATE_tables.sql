DROP SCHEMA IF EXISTS SchoolLibrary;
CREATE SCHEMA SchoolLibrary;
USE SchoolLibrary;

CREATE TABLE school_unit
(
	id INT AUTO_INCREMENT,
		PRIMARY KEY(id),
	name VARCHAR(50) NOT NULL,
	address VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	phone CHAR(10) NOT NULL,
	email VARCHAR(50) UNIQUE NOT NULL,
	principal_name VARCHAR(50) NOT NULL,
    is_active BOOL NOT NULL
);

-- currently each user has only one role, we can later give multiple roles to a user
-- only consistent tuples are (admin, NULL, active) or (other_user, school_id, active/inactive)
CREATE TABLE user
(
	id INT AUTO_INCREMENT,
		PRIMARY KEY(id),
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(30) NOT NULL,
    role ENUM('admin', 'manager', 'member-teacher', 'member-student') NOT NULL,
    school_id INT, -- can be null in admin
		FOREIGN KEY(school_id) REFERENCES school_unit(id),
    is_active BOOL NOT NULL,
    name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE book_title
(
	id INT AUTO_INCREMENT,
		PRIMARY KEY(id),
	-- TEMPORARLY UNIQUE FOR TESTING PURPOSES
	title VARCHAR(100) UNIQUE,
	publisher VARCHAR(100) NOT NULL,
	isbn CHAR(17) UNIQUE NOT NULL,
    pages INT NOT NULL,
	summary MEDIUMTEXT NOT NULL,
	image VARCHAR(200) ,
	lang_id CHAR(2) NOT NULL
);

CREATE TABLE categories
(
	id INT AUTO_INCREMENT,
		PRIMARY KEY(id),
	category VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE book_categories
(
	book_id INT NOT NULL,
	category_id INT NOT NULL,
		PRIMARY KEY(book_id, category_id),
	FOREIGN KEY (book_id) REFERENCES book_title(id),
	FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE authors
(
	id INT AUTO_INCREMENT, 
		PRIMARY KEY(id),
	author VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE book_authors
(
	book_id INT NOT NULL,
	author_id INT NOT NULL, 
		PRIMARY KEY(book_id, author_id),
	FOREIGN KEY(book_id) REFERENCES book_title(id),
	FOREIGN KEY(author_id) REFERENCES authors(id)
);

CREATE TABLE keywords
(
	id int auto_increment,
		PRIMARY KEY(id),
	keyword varchar(100) unique not null
);

CREATE TABLE book_keywords
(
	book_id int not null,
	keyword_id int not null,
		PRIMARY KEY(book_id, keyword_id),
	foreign key(book_id) references book_title(id),
	foreign key(keyword_id) references keywords(id)
);

create table book_instance	
(
	id int auto_increment,
    	primary key(id),
    book_id int not null,
	school_id int not null,
	copies int not null,
	foreign key(school_id) references school_unit(id),
	foreign key(book_id) references book_title(id)
);

create table review
(
	id int auto_increment,
		primary key(id),
	user_id int not null,
	book_id int not null,
	foreign key(user_id) references user(id),
	foreign key(book_id) references book_title(id),
	opinion text not null,
	stars int not null,
	is_active bool not null -- approved is needed only if we have to deal with a student
);

create table borrowing
(
	id int auto_increment,
		PRIMARY KEY(id),
	user_id int not null, 
	book_id int not null,
    status ENUM('active', 'delayed', 'completed') NOT NULL,
	manager_id int not null,
	borrow_date date,
	return_date date,
    -- expire_date = borrowing_date + 1week
	-- maxBorrowingTime date,
	foreign key(user_id) references user(id),
	foreign key(book_id) references book_title(id),
	foreign key(manager_id) references user(id)
);

create table reservation
(
    id int auto_increment,
		PRIMARY KEY(id),
    book_id int not null,
    user_id int not null,
    status ENUM('pending', 'active', 'expired') NOT NULL,
    request_date date not null,
    reserve_date date not null,
    -- expire_date = borrowing_date + 1week
    -- expiringDate date not null,
    foreign key (user_id) references user(id),
    foreign key (book_id) references book_title(id)
);

DELIMITER //
-- this activates pending reservation when the requested book_instance becomes available
-- there are no reservation before inserting the book_instance on the library
CREATE TRIGGER activateReservation AFTER UPDATE ON book_instance FOR EACH ROW
BEGIN
	-- add copies one by one in the database
	IF NEW.copies > 0 AND EXISTS (SELECT * FROM reservation WHERE reservation.book_id = NEW.book_id AND reservation.status = 'pending') THEN
		-- make reservation 'active' from 'pending'
        UPDATE reservation
        SET reservation.status = 'active' AND reservation.reservation_date = CURRENT_DATE()
        WHERE reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        -- bind one copy of the book_instance for the reservation just activated
		UPDATE book_instance SET book_instance.copies = book_instance.copies-1 WHERE book_istance.id = NEW.book_id;
    END IF;
END //

DELIMITER |

-- for borrowings delayed
-- for reservations expired
CREATE EVENT e_daily
    ON SCHEDULE
      EVERY 1 DAY
    DO
      BEGIN
		-- update dalyed borrowings
		UPDATE borrowing
        SET borrowing.status = 'delayed'
        WHERE borrowing.status = 'active' AND CURRENT_DATE() > DATE_ADD(borrowing.borrow_date, INTERVAL 1 WEEK);
        
        -- update expired reservations (whether they are pending or active)
        UPDATE reservation, book_instance
        SET reservation.status = 'expired' AND book_instance.copies = book_instance.copies+1
        WHERE (reservation.status = 'pending' AND CURRENT_DATE() > DATE_ADD(reservation.request_date, INTERVAL 1 WEEK))
			OR (reservation.status = 'active' AND CURRENT_DATE() > DATE_ADD(reservation.reserve_date, INTERVAL 1 WEEK));
      END |

DELIMITER ;


