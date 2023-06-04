
CREATE database SchoolLibrary;
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
	isbn VARCHAR(17) UNIQUE NOT NULL,
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

-- 500 records to ensure that books have at least 2 authors (id was put sequentially)
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
(  id int auto_increment,
    primary key(id),
    book_id int not null ,
	school_id int not null,
	copies int not null,
	foreign key(school_id) references school_unit(id),
	foreign key(book_id) references book_title(id),
    unique(school_id,book_id)
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
	borrow_date date not null,
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
    reserve_date date,
    -- expire_date = borrowing_date + 1week
    -- expiringDate date not null,
    foreign key (user_id) references user(id),
    foreign key (book_id) references book_title(id)
);

DELIMITER //
DROP TRIGGER IF EXISTS activateReservationOnUpdate//
-- this activates pending reservation when the requested book_instance becomes available
-- there are no reservation before inserting the book_instance on the library
CREATE TRIGGER activateReservationOnUpdate BEFORE UPDATE ON book_instance FOR EACH ROW
BEGIN
	-- add copies one by one in the database
	WHILE NEW.copies > 0 AND EXISTS (
		SELECT * FROM reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
	) DO
		-- make reservation 'active' from 'pending'
        UPDATE reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        SET reservation.status = 'active', reservation.reserve_date = CURRENT_DATE()
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        -- bind one copy of the book_instance for the reservation just activated
        SET NEW.copies = NEW.copies-1;
    END WHILE;
END //	
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS activateReservationOnInsert//
-- this activates pending reservation when the requested book_instance becomes available
-- there are no reservation before inserting the book_instance on the library
CREATE TRIGGER activateReservationOnInsert BEFORE INSERT ON book_instance FOR EACH ROW
BEGIN
	-- add copies one by one in the database
	WHILE NEW.copies > 0 AND EXISTS (
		SELECT * FROM reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
	) DO
		-- make reservation 'active' from 'pending'
        UPDATE reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        SET reservation.status = 'active', reservation.reserve_date = CURRENT_DATE()
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        -- bind one copy of the book_instance for the reservation just activated
        SET NEW.copies = NEW.copies-1;
    END WHILE;
END //	
DELIMITER ;

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
        
        -- update expired reservations (from pending)
        UPDATE reservation
        SET reservation.status = 'expired'
        WHERE (reservation.status = 'pending' AND CURRENT_DATE() > DATE_ADD(reservation.request_date, INTERVAL 1 WEEK));
		
        -- upadate expired reservations (from active)
        UPDATE reservation, book_instance
        SET reservation.status = 'expired', book_instance.copies = book_instance.copies+1
        WHERE (reservation.status = 'active' AND CURRENT_DATE() > DATE_ADD(reservation.reserve_date, INTERVAL 1 WEEK));
      END |

DELIMITER ;


/* Indexes */
create index book_title_id_idx on book_categories(book_id);
create index book_title_id_idx on book_authors(book_id);
create index school_unit_id_idx on user(school_id);
create index user_id_idx on review(user_id);
create index book_title_idx on review(book_id);
create index book_title_id_idx on book_keywords(book_id);
create index number_of_copies_idx on book_instance(copies);
create index borrowing_date_idx on borrowing(borrow_date);
create index date_of_birth_idx on user(birth_date);

-- Useful Procedures

USE SchoolLibrary;


delimiter //

DROP PROCEDURE IF EXISTS revise_authors;//
create procedure revise_authors (IN auth VARCHAR(40), IN bookid INT) BEGIN
IF NOT EXISTS (SELECT id FROM authors WHERE author = auth)
THEN INSERT INTO authors (author) VALUES (auth);
END IF;
INSERT INTO book_authors (author_id, book_id)
VALUES ((SELECT id FROM authors WHERE author = auth), bookid) ;
END;
//

DROP PROCEDURE IF EXISTS revise_categories;//
create procedure revise_categories (IN cat VARCHAR(40), IN bookid INT) BEGIN
IF NOT EXISTS (SELECT id FROM categories WHERE category = cat)
THEN INSERT INTO categories (category) VALUES (cat);
END IF;
INSERT INTO book_categories (category_id, book_id)
VALUES ((SELECT id FROM categories WHERE category = cat), bookid) ;
END;
//

DROP PROCEDURE IF EXISTS revise_keywords;//
create procedure revise_keywords (IN word VARCHAR(40), IN bookid INT) BEGIN
IF NOT EXISTS (SELECT id FROM keywords WHERE keyword = word)
THEN INSERT INTO keywords (keyword) VALUES (word);
END IF;
INSERT INTO book_keywords (keyword_id, book_id)
VALUES ((SELECT id FROM keywords WHERE keyword = word), bookid) ;
END;
//

DROP PROCEDURE IF EXISTS total_reservations;//
create procedure total_reservations (IN usrid INT) BEGIN
SELECT COUNT(*) as active_reservations FROM 
reservation INNER JOIN user ON reservation.user_id = user.id
WHERE user.id = usrid
GROUP BY user.id ;
END;//

DROP PROCEDURE IF EXISTS is_reserved;//
create procedure is_reserved (IN usrid INT, in bookid INT) BEGIN
SELECT * FROM 
reservation INNER JOIN user ON reservation.user_id = user.id 
WHERE user.id = usrid AND reservation.book_id = bookid ;
END;//

-- Final Queries

/* Member queries */
DROP PROCEDURE IF EXISTS filter_title;//
create procedure filter_title (IN schoolid INT, IN title VARCHAR (40)) BEGIN
SELECT title, copies, book_title.id FROM 
book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
WHERE book_instance.school_id = schoolid AND book_title.title = title ;
END;//

DROP PROCEDURE IF EXISTS filter_category;//
create procedure filter_category (IN schoolid INT, IN select_category VARCHAR (40) ) BEGIN
SELECT BT1.title, BI1.copies, BT1.id FROM 
book_title AS BT1 INNER JOIN book_instance AS BI1 ON BT1.id = BI1.book_id 
INNER JOIN book_categories AS BC ON BC.book_id = BI1.book_id
INNER JOIN categories AS C ON C.id = BC.category_id
WHERE BI1.school_id = schoolid AND C.category = select_category ;
END; //

DROP PROCEDURE IF EXISTS filter_author;//
create procedure filter_author (IN schoolid INT, IN select_author VARCHAR (40)) BEGIN
SELECT BT1.title, BI1.copies, BT1.id FROM 
book_title AS BT1 INNER JOIN book_instance AS BI1 ON BT1.id = BI1.book_id 
INNER JOIN book_authors AS BA ON BA.book_id = BI1.book_id
INNER JOIN authors AS A ON A.id = BA.author_id
WHERE BI1.school_id = schoolid AND A.author = select_author;
END; //

DROP PROCEDURE IF EXISTS my_borrows;//
create procedure my_borrows (IN usrid INT) BEGIN

END; //


/*Admin Queries*/

/*3.1.1*/

DELIMITER //

DROP PROCEDURE IF EXISTS borrows_per_school;//
create procedure borrows_per_school (IN defineMonth INT, IN defineYear INT) BEGIN 
	SELECT school_unit.name, school_unit.id, COUNT(*) as total
	FROM borrowing INNER JOIN user ON borrowing.manager_id = user.id 
	INNER JOIN school_unit ON school_unit.id = user.school_id
	WHERE MONTH(borrowing.borrow_date) = defineMonth AND YEAR(borrowing.borrow_date) = defineYear
	GROUP BY user.school_id
    ORDER BY total DESC;
END;//


/*3.1.2*/

DROP PROCEDURE IF EXISTS author_writes_category;//
create procedure author_writes_category (IN select_category VARCHAR(20)) BEGIN
	SELECT DISTINCT(author) FROM authors
    JOIN book_authors ON authors.id = book_authors.author_id
    JOIN book_categories ON book_categories.book_id = book_authors.book_id
    JOIN categories ON categories.id = book_categories.category_id
	WHERE categories.category = select_category;
END;
//

DROP PROCEDURE IF EXISTS teachers_reading_category;//
create procedure teachers_reading_category(IN select_category VARCHAR (20)) BEGIN
	SELECT user.name, user.username, user.id FROM
	user INNER JOIN borrowing ON borrowing.user_id = user.id
	INNER JOIN book_title ON book_title.id = borrowing.book_id
	INNER JOIN book_categories ON book_categories.book_id = book_title.id
	INNER JOIN categories ON categories.id = book_categories.category_id
	WHERE user.role = 'member-teacher' AND categories.category = select_category
    GROUP BY user.id;
END; //

/*3.1.3*/

DROP PROCEDURE IF EXISTS young_teachers_book_worms;//
create procedure young_teachers_book_worms () BEGIN
	SELECT name, username, user.id, user.birth_date, COUNT(borrowing.id) AS num_of_borrows FROM 
	user INNER JOIN borrowing ON user.id = borrowing.user_id
    WHERE user.role = 'member-teacher' AND DATE_SUB(CURRENT_DATE(), INTERVAL 40 YEAR) < user.birth_date
	-- WHERE user.role = 'member-teacher' AND YEAR(current_timestamp())-YEAR(user.birth_date) < 27
	GROUP BY user.id ORDER BY num_of_borrows DESC;
END;
//

/*3.1.4*/

DROP PROCEDURE IF EXISTS authors_with_zero_borrows;//
create procedure authors_with_zero_borrows()
BEGIN
    SELECT authors.id, authors.author
    FROM authors
    WHERE NOT EXISTS(
		SELECT * FROM borrowing
        INNER JOIN book_title
        ON book_title.id = borrowing.book_id
        INNER JOIN book_authors
        ON book_title.id = book_authors.book_id
        WHERE book_authors.author_id = authors.id
    );
END //

/*3.1.5*/

DROP PROCEDURE IF EXISTS equal_lends;//
	create procedure equal_lends () BEGIN
	WITH aux_tab AS
	(SELECT USR1.name, USR1.username, USR1.id, COUNT(BR1.id) lend_count FROM 
	user USR1 INNER JOIN borrowing BR1 ON USR1.id = BR1.manager_id
	WHERE BR1.borrow_date > DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
	GROUP BY (USR1.id) )
	SELECT USR1.name, USR1.username, USR1.id, USR1.lend_count, COUNT(USR2.id) AS match_count FROM
	aux_tab USR1 INNER JOIN aux_tab USR2 ON USR1.lend_count = USR2.lend_count
	WHERE USR1.id <> USR2.id 
	GROUP BY USR1.id, USR1.lend_count
	HAVING USR1.lend_count > 20
	ORDER BY lend_count DESC;
END;
//

/*3.1.6*/
DROP PROCEDURE IF EXISTS top_pairs;//
create procedure top_pairs () BEGIN
	SELECT c1.category AS category1, c2.category AS category2, COUNT(*) AS total_borrows
	FROM borrowing b
    JOIN book_categories bc1 ON bc1.book_id = b.book_id
	JOIN book_categories bc2 ON bc2.book_id = b.book_id AND bc1.category_id < bc2.category_id
	JOIN categories c1 ON c1.id = bc1.category_id
	JOIN categories c2 ON c2.id = bc2.category_id
	GROUP BY category1, category2
	ORDER BY total_borrows DESC
	LIMIT 3;
END ; //

/*3.1.7*/
DROP PROCEDURE IF EXISTS authors_below_top;//
create procedure authors_below_top()
BEGIN
	-- SELECT a1.author, COUNT(ba1.book_id) as cnt1
--     FROM authors as a1
--     JOIN book_authors as ba1
--     ON a1.id = ba1.author_id
--     WHERE EXISTS(
-- 		SELECT COUNT(ba2.book_id) as cnt2
--         FROM authors as a2
--         JOIN book_authors as ba2
--         ON a2.id = ba2.author_id
-- 		WHERE cnt2 >= cnt1+5
--         GROUP BY a2.id
-- 	)
--     GROUP BY a1.id; 
    
	SELECT A1.author, COUNT(BA1.book_id) AS num_of_books 
	FROM authors AS A1 JOIN book_authors AS BA1 ON A1.id = BA1.author_id
	GROUP BY A1.id
	HAVING COUNT(BA1.book_id) <= (SELECT MAX(top_book_count) - 5 FROM 
	(SELECT COUNT(BA2.book_id) AS top_book_count FROM 
	authors AS A2 JOIN book_authors AS BA2 ON A2.id = BA2.author_id 
	GROUP BY A2.id) AS author_counts);
END //


/* manager queries */

/*3.2.1 filter author, category ,title-->same procedures as user */

-- filter number of copies
DROP PROCEDURE IF EXISTS filter_copies;//
	create procedure filter_copies (IN lib_id INT, IN selected_copies INT) BEGIN
	SELECT book_title.title, book_instance.copies, book_title.id FROM 
	book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
	WHERE book_instance.school_id = lib_id AND book_instance.copies = selected_copies ;
END;
// 


/*3.2.2*/
DROP PROCEDURE IF EXISTS red_flag_users;//
create procedure red_flag_users (IN delay_days INT, IN full_name VARCHAR(40), IN lib_id INT) BEGIN
	SELECT user.name, user.username, user.id, COUNT(*) AS total_delays
    FROM user JOIN borrowing ON borrowing.user_id = user.id
	WHERE user.school_id = lib_id AND borrowing.status = 'delayed'
		AND (full_name = '#all' OR full_name = user.name)
		AND DATE_ADD(borrowing.borrow_date, INTERVAL 7 DAY) <= DATE_SUB(CURRENT_DATE(), INTERVAL delay_days DAY)
		GROUP BY user.id
		ORDER BY total_delays DESC;
END;
//

/*3.2.3*/

-- filter user
DROP PROCEDURE IF EXISTS average_rating;//
create procedure average_rating (IN lib_id INT, IN select_name VARCHAR(40), IN select_category VARCHAR(40) ) BEGIN
	SELECT user.name, user.username, user.id, categories.category, AVG(review.stars)
    FROM user JOIN review ON user.id = review.user_id
    JOIN book_categories ON review.book_id = book_categories.book_id
    JOIN categories ON book_categories.category_id = categories.id
    WHERE user.school_id = lib_id AND (select_name = '#all' OR select_name = user.name)
		AND (select_category = '#all' OR select_category = categories.category)
	GROUP BY user.id, categories.id;
END; 
//

-- check here

DROP PROCEDURE IF EXISTS average_user_rating;//
-- create procedure average_user_rating (IN lib_id INT, IN select_name VARCHAR(40) ) BEGIN
-- 	SELECT user.username, AVG(stars) FROM 
-- 	review INNER JOIN user ON review.user_id = user.id
-- 	WHERE user.school_id = lib_id AND user.username = select_name ;
-- END; 
-- //

-- filter category

-- check here
DROP PROCEDURE IF EXISTS average_category_rating;//
-- create procedure average_category_rating (IN lib_id INT, IN select_category VARCHAR(40)) BEGIN
-- SELECT AVG (stars) FROM 
-- review INNER JOIN book_title ON review.book_id = book_title.id
-- INNER JOIN book_categories ON book_categories.book_id = book_title.id
-- INNER JOIN categories ON categories.id = book_categories.category_id 
-- WHERE categories.category = select_category ;
-- END; //
