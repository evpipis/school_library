USE SchoolLibrary;

-- Useful Procedures

delimiter //

create procedure revise_authors (IN auth VARCHAR(40), IN bookid INT) BEGIN
IF NOT EXISTS (SELECT id FROM authors WHERE author = auth)
THEN INSERT INTO authors (author) VALUES (auth);
END IF;
INSERT INTO book_authors (author_id, book_id)
VALUES ((SELECT id FROM authors WHERE author = auth), bookid) ;
END;
//

create procedure revise_categories (IN cat VARCHAR(40), IN bookid INT) BEGIN
IF NOT EXISTS (SELECT id FROM categories WHERE category = cat)
THEN INSERT INTO categories (category) VALUES (cat);
END IF;
INSERT INTO book_categories (category_id, book_id)
VALUES ((SELECT id FROM categories WHERE category = cat), bookid) ;
END;
//

create procedure revise_keywords (IN word VARCHAR(40), IN bookid INT) BEGIN
IF NOT EXISTS (SELECT id FROM keywords WHERE keyword = word)
THEN INSERT INTO keywords (keyword) VALUES (word);
END IF;
INSERT INTO book_keywords (keyword_id, book_id)
VALUES ((SELECT id FROM keywords WHERE keyword = word), bookid) ;
END;
//

create procedure total_reservations (IN usrid INT) BEGIN
SELECT COUNT(*) as active_reservations FROM 
reservation INNER JOIN user ON reservation.user_id = user.id
WHERE user.id = usrid
GROUP BY user.id ;
END;//

create procedure is_reserved (IN usrid INT, in bookid INT) BEGIN
SELECT * FROM 
reservation INNER JOIN user ON reservation.user_id = user.id 
WHERE user.id = usrid AND reservation.book_id = bookid ;
END;//

-- Final Queries

/* Member queries */

create procedure filter_title (IN schoolid INT, IN title VARCHAR (40)) BEGIN
SELECT title, copies, book_title.id FROM 
book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
WHERE book_instance.school_id = schoolid AND book_title.title = title ;
END;//

create procedure filter_category (IN schoolid INT, IN select_category VARCHAR (40) ) BEGIN
SELECT BT1.title, BI1.copies, BT1.id FROM 
book_title AS BT1 INNER JOIN book_instance AS BI1 ON BT1.id = BI1.book_id 
INNER JOIN book_categories AS BC ON BC.book_id = BI1.book_id
INNER JOIN categories AS C ON C.id = BC.category_id
WHERE BI1.school_id = schoolid AND C.category = select_category ;
END; //

create procedure filter_author (IN schoolid INT, IN select_author VARCHAR (40)) BEGIN
SELECT BT1.title, BI1.copies, BT1.id FROM 
book_title AS BT1 INNER JOIN book_instance AS BI1 ON BT1.id = BI1.book_id 
INNER JOIN book_authors AS BA ON BA.book_id = BI1.book_id
INNER JOIN authors AS A ON A.id = BA.author_id
WHERE BI1.school_id = schoolid AND A.author = select_author;
END; //

create procedure my_borrows (IN usrid INT) BEGIN

END; //


/*Admin Queries*/

/*3.1.1*/

DROP procedure borrows_per_school;//

create procedure borrows_per_school (IN defineMonth INT, IN defineYear INT) BEGIN 
SELECT COUNT(*), school_unit.name
FROM borrowing INNER JOIN user ON borrowing.manager_id = user.id 
INNER JOIN school_unit ON school_unit.id = user.school_id
WHERE MONTH(borrowing.borrow_date) = defineMonth AND YEAR(borrowing.borrow_date) = defineYear
GROUP BY user.school_id ;
END;//


/*3.1.2*/

DROP procedure author_writes_category;//

create procedure author_writes_category (IN select_category VARCHAR(20)) BEGIN
SELECT author FROM
author INNER JOIN book_authors ON authors.id = book_authors.author_id
INNER JOIN book_title ON book_title.id = book_authors.book_id
INNER JOIN book_categories ON book_categories.book_id = book_title.id
INNER JOIN categories ON categories.id = book_categories.category_id
WHERE categories.category = select_category ;
END;
//

DROP procedure teachers_reading_category ;//

create procedure teachers_reading_category(IN select_category VARCHAR (20)) BEGIN
SELECT user.name FROM
user INNER JOIN borrowing ON borrowing.user_id = user.id
INNER JOIN book_instance ON book_instance.id = borrowing.book_id
INNER JOIN book_title ON book_title.id = book_instance.book_id
INNER JOIN book_categories ON book_categories.book_id = book_title.id
INNER JOIN categories ON categories.id = book_categories.category_id
WHERE categories.category = select_category ;
END; //

/*3.1.3*/
DROP procedure young_teachers_book_worms ; //

create procedure young_teachers_book_worms () BEGIN
SELECT name, COUNT(borrowing.id) AS num_of_borrows FROM 
user INNER JOIN borrowing ON user.id = borrowing.user_id
WHERE user.role = 'member-teacher' AND YEAR(current_timestamp())-YEAR(user.birth_date) < 40
GROUP BY user.id ORDER BY num_of_borrows DESC;
END;
//

/*3.1.4*/

DROP procedure authors_with_zero_borrows; //

create procedure authors_with_zero_borrows()
BEGIN
    SELECT authors.id, authors.author
    FROM authors
    LEFT JOIN book_authors ON authors.id = book_authors.author_id
    LEFT JOIN book_instance ON book_authors.book_id = book_instance.book_id
    LEFT JOIN borrowing ON book_instance.id = borrowing.book_id
    WHERE borrowing.id IS NULL;
END //

/*3.1.5*/
DROP procedure equal_lends ; //

create procedure equal_lends () BEGIN
WITH aux_tab AS
(SELECT USR1.name, USR1.id, COUNT(BR1.id) lend_count FROM 
user USR1 INNER JOIN borrowing BR1 ON USR1.id = BR1.manager_id
WHERE BR1.borrow_date > DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
GROUP BY (USR1.id) )
SELECT USR1.name, USR1.lend_count, COUNT(USR2.id) AS match_count FROM
aux_tab USR1 INNER JOIN aux_tab USR2 ON USR1.lend_count = USR2.lend_count
WHERE USR1.id <> USR2.id 
GROUP BY USR1.id, USR1.lend_count
HAVING USR1.lend_count > 20 ;
END;
//

/*3.1.6*/
DROP procedure top_pairs ;//

create procedure top_pairs () BEGIN
SELECT c1.category AS category1, c2.category AS category2, COUNT(*) AS total_borrows
FROM book_categories bc1
JOIN book_categories bc2 ON bc1.book_id = bc2.book_id 
JOIN categories c1 ON bc1.book_id = c1.id
JOIN categories c2 ON bc2.book_id = c2.id
JOIN book_instance bc ON bc.book_id = bc1.book_id
JOIN borrowing b ON b.book_id = bc.id
GROUP BY category1, category2
ORDER BY total_borrows DESC
LIMIT 3;
END ; //

/*3.1.7*/
create procedure authors_below_top()
BEGIN
    SELECT A1.name, COUNT(BA1.book_id) AS num_of_books
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
create procedure filter_copies (IN lib_id INT, IN selected_copies INT) BEGIN
SELECT book_title.title, book_instance.copies, book_title.id FROM 
book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
WHERE book_instance.school_id = lib_id AND book_instance.copies = selected_copies ;
END;
// 


/*3.2.2*/
create procedure red_flag_users (IN delay_days INT, IN full_name VARCHAR(40), IN lib_id INT) BEGIN
SELECT USR.id FROM
user AS USR INNER JOIN borrowing AS BR ON USR.id = BR.user_id
WHERE DAY(current_timestamp()) >= (DAY(borrowing.borrow_date) + (delay_days + 7) ) AND BR.return_date is NULL 
AND borrowing.status = 'delayed'
AND USR.school_id = lib_id AND USR.name = full_name 
GROUP BY USR.id;
END;
//

/*3.2.3*/

-- filter user

-- check here
DROP procedure average_user_rating ;

create procedure average_user_rating (IN lib_id INT, IN select_name VARCHAR(40) ) BEGIN
SELECT user.username, AVG(stars) FROM 
review INNER JOIN user ON review.user_id = user.id
WHERE user.school_id = lib_id AND user.username = select_name ;
END; 
//

-- filter category

-- check here
create procedure average_category_rating (IN lib_id INT, IN select_category VARCHAR(40)) BEGIN
SELECT AVG (stars) FROM 
review INNER JOIN book_title ON review.book_id = book_title.id
INNER JOIN book_categories ON book_categories.book_id = book_title.id
INNER JOIN categories ON categories.id = book_categories.category_id 
WHERE categories.category = select_category ;
END; //
