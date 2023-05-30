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
	('member-student3', 'member-student3', 'member-student', 1, FALSE, 'Student 3', '2000-01-01')
;
