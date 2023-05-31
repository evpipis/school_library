use schoolLibrary;

/* member-student queries*/

/*3.3.2*/

-- filter title
create procedure filter_title (IN lib_id INT, IN bookTitle VARCHAR (60))
BEGIN
	SELECT title, copies, book_title.id
    FROM book_title INNER JOIN book_instance ON book_title.id = book_instance.book_id 
	WHERE book_instance.school_id = lib_id AND book_title.title = bookTitle;
END;
// 
/*
-- filter author 
SELECT BT1.id FROM 
BookTitle AS BT1 INNER JOIN BookCopy AS BC1 ON BT1.id = BC1.BookTitleId 
INNER JOIN bookAuthors AS BA ON BA.bookTitleId = BC1.bookTitleId
INNER JOIN author AS A ON A.id = BA.authorId
WHERE BC1.schoolUnitId = '1' AND A.authorName = 'michelangelo';
//
create procedure filter_author (IN lib_id INT, IN author_name VARCHAR(60))BEGIN
SELECT BT1.title, BC1.numberOfCopies, BT1.id FROM 
BookTitle AS BT1 INNER JOIN BookCopy AS BC1 ON BT1.id = BC1.BookTitleId 
INNER JOIN bookAuthors AS BA ON BA.bookTitleId = BC1.bookTitleId
INNER JOIN author AS A ON A.id = BA.authorId
WHERE BC1.schoolUnitId = lib_id AND A.authorName = author_name ;
END;
//

-- filter category
SELECT BT1.id FROM
BookTitle AS BT1 INNER JOIN bookCopy AS BC1 ON BT1.id = BC1.bookTitleId 
INNER JOIN bookCategories AS BC ON BC.bookTitleId = BC1.bookTitleId
INNER JOIN categories AS C ON C.id = BC.bookCategoryId
WHERE BC1.schoolUnitId = '2' AND C.category = 'mickey mouse' ;
//


create procedure filter_category (IN lib_id INT, IN select_category VARCHAR(20)) BEGIN
SELECT BT1.title, BC1.numberOfCopies, BT1.id FROM
BookTitle AS BT1 INNER JOIN bookCopy AS BC1 ON BT1.id = BC1.bookTitleId 
INNER JOIN bookCategories AS BC ON BC.bookTitleId = BC1.bookTitleId
INNER JOIN categories AS C ON C.id = BC.bookCategoryId
WHERE BC1.schoolUnitId = lib_id AND C.category = select_category ;
END;
//*/