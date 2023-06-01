USE SchoolLibrary;

INSERT INTO school_unit
	(name, address, city, phone, email, principal_name, is_active)
VALUES
	('Evangeliki Model High School', 'Lesvou 4', 'Nea Smyrni', '2109316748', 'evangeliki@mail.com', 'Christos Fanidis', TRUE),
    ('Leontios High School', 'Themistokli Sofouli 2', 'Nea Smyrni', '2109418011', 'l_leonin@leonteios.gr', 'Leontios Principal', TRUE),
    ('The Great High School', 'the great address', 'the great city', '490445', 'thegreat@mail.com', 'Principal The Great', FALSE)
;

INSERT INTO user
	(username, password, role, school_id, is_active, name, birth_date)
VALUES
	('admin', 'admin', 'admin', NULL, TRUE, 'Admin', '2000-01-01'),
	('manager1', 'manager1', 'manager', 1, TRUE, 'Manager 1', '2000-01-01'),
	('manager2', 'manager2', 'manager', 2, TRUE, 'Manager 2', '2000-01-01'),
	('manager3', 'manager3', 'manager', 1, FALSE, 'Manager 3', '2000-01-01'),
	('member-teacher1', 'member-teacher1', 'member-teacher', 1, TRUE, 'Teacher 1', '2000-01-01'),
	('member-teacher2', 'member-teacher2', 'member-teacher', 2, TRUE, 'Teacher 2', '2000-01-01'),
	('member-student1', 'member-student1', 'member-student', 1, TRUE, 'Student 1', '2000-01-01'),
	('member-student2', 'member-student2', 'member-student', 2, TRUE, 'Student 2', '2000-01-01'),
	('member-student3', 'member-student3', 'member-student', 1, FALSE, 'Student 3', '2000-01-01'),
    ('other1', 'other1', 'member-student', 1, TRUE, 'Other 1', '2000-01-01'),
    ('other2', 'other2', 'member-student', 1, TRUE, 'Other 2', '2000-01-01'),
    ('other3', 'other3', 'member-student', 1, TRUE, 'Other 3', '2000-01-01')
;

INSERT INTO book_title
	(title, publisher, isbn, summary, image, lang_id, pages)
VALUES
	('Book 1', 'HarperCollins', '397275289-X', 'Ut labore et dolore magna aliqua', 'http://dummyimage.com/104x177.png/ff4444/ffffff', 'gd', 358),
	('Book 2','HarperCollins', '640431927-6','Consectetur adipiscing elit','http://dummyimage.com/112x239.png/dddddd/000000', 'kw', 123),
    ('Book 3','Hachette Book Group', '567789573-3', 'Lorem ipsum dolor sit amet','http://dummyimage.com/243x192.png/dddddd/000000', 'bn', 605)
;

INSERT INTO categories
	(category)
VALUES
	('Augmented Reality'),
    ('Cooking'),
    ('Zombies'),
    ('Alternate History'),
    ('Werewolves')
;

INSERT INTO book_categories
	(book_id, category_id)
VALUES
	(1, 2),
    (1, 4),
    (2, 1),
    (2, 2),
    (2, 3),
    (3, 2),
    (3, 5)
;

INSERT INTO authors
	(author)
VALUES
	('John Smith'),
    ('Emily Johnson'),
    ('David Lee'),
    ('Sarah Davis'),
    ('Michael Wilson'),
    ('Amanda Rodriguez')
;

INSERT INTO book_authors
	(book_id, author_id)
VALUES
	(1, 1),
    (1, 5),
    (1, 6),
    (2, 2),
    (3, 4),
    (3, 2),
    (3, 5)
;

INSERT INTO keywords
	(keyword)
VALUES
	('mystery'),
    ('romance'),
    ('fantasy'),
    ('sci-fi'),
    ('biography'),
    ('travel')
;

INSERT INTO book_keywords
	(book_id, keyword_id)
VALUES
	(1, 1),
    (1, 3),
    (1, 5),
    (2, 2),
    (2, 3),
    (2, 6),
    (3, 5)
;

INSERT INTO book_instance
	(book_id, school_id, copies)
VALUES
	(1, 1, 4),
    (2, 1, 3),
    (1, 2, 2),
    (3, 2, 1),
    (1, 3, 2)
;

-- INSERT INTO borrowing
-- 	(user_id, book_id, manager_id, status, borrow_date, return_date)
-- VALUES
-- 	(10, 1, 2, 'completed', '2023-05-22', '2023-05-27'),
--     (12, 2, 2, 'completed', '2023-05-25', '2023-05-29'),
--     (10, 2, 2, 'active', '2023-05-26', NULL),
--     (11, 2, 2, 'active', '2023-05-30', NULL)
-- ;

-- INSERT INTO reservation
-- 	(user_id, book_id, status, request_date, reserve_date)
-- VALUES
-- 	(7, 2, 'pending', '2023-06-01', NULL),
--     (5, 2, 'pending', '2023-06-01', NULL),
--     (7, 1, 'active', '2023-06-01', '2023-06-01')
-- ;