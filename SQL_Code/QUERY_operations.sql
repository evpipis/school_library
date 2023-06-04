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

-- filter everything
-- DROP PROCEDURE IF EXISTS filter_everything;//
-- create procedure filter_everything (IN schoolid INT, IN title VARCHAR (40), IN cat VARCHAR(40), IN word VARCHAR(40)) BEGIN
-- 	SELECT book_title.title, book_instance.copies, book_title.id FROM 
-- 	book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
-- 	WHERE book_instance.school_id = schoolid
-- 		AND (title = '#all' OR book_title.title = title)
--         AND (cat = '#all' OR cat = book_
-- END;//


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
		AND review.is_active = TRUE AND(select_category = '#all' OR select_category = categories.category)
	GROUP BY user.id, categories.id;
END; 
//

-- check here

-- DROP PROCEDURE IF EXISTS average_user_rating;//
-- create procedure average_user_rating (IN lib_id INT, IN select_name VARCHAR(40) ) BEGIN
-- 	SELECT user.username, AVG(stars) FROM 
-- 	review INNER JOIN user ON review.user_id = user.id
-- 	WHERE user.school_id = lib_id AND user.username = select_name ;
-- END; 
-- //

-- filter category

-- check here
-- DROP PROCEDURE IF EXISTS average_category_rating;//
-- create procedure average_category_rating (IN lib_id INT, IN select_category VARCHAR(40)) BEGIN
-- SELECT AVG (stars) FROM 
-- review INNER JOIN book_title ON review.book_id = book_title.id
-- INNER JOIN book_categories ON book_categories.book_id = book_title.id
-- INNER JOIN categories ON categories.id = book_categories.category_id 
-- WHERE categories.category = select_category ;
-- END; //
