USE SchoolLibrary;

INSERT INTO school_unit
	(name, address, city, phone, email, principal_name)
VALUES
	('Evangeliki Model High School', 'Lesvou 4', 'Nea Smyrni', '2109316748', NULL, 'Christos Fanidis'),
    ('Leontios High School', 'Themistokli Sofouli 2', 'Nea Smyrni', '2109418011', 'l_leonin@leonteios.gr', NULL)
;

INSERT INTO user
	(username, password, role, school_id, is_active)
VALUES
	('admin', 'admin', 'admin', NULL, TRUE),
	('manager1', 'manager1', 'manager', 1, TRUE),
	('manager2', 'manager2', 'manager', 2, TRUE),
	('manager3', 'manager3', 'manager', 1, FALSE),
	('member-teacher1', 'member-teacher1', 'member-teacher', 1, TRUE),
	('member-teacher2', 'member-teacher2', 'member-teacher', 2, TRUE),
	('member-student1', 'member-student1', 'member-student', 1, TRUE),
	('member-student2', 'member-student2', 'member-student', 2, TRUE),
	('member-student3', 'member-student3', 'member-student', 1, FALSE)
;

