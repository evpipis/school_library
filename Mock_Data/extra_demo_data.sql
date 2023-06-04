/* some demo data */

INSERT INTO user
	(username, password, role, school_id, is_active, name, birth_date)
VALUES
	('admin', 'admin', 'admin', NULL, TRUE, 'Admin', '1976-06-03'),
	('manager1', 'manager1', 'manager', 1, TRUE, 'Manager 1', '1989-10-15'),
	('member-teacher1', 'member-teacher1', 'member-teacher', 1, TRUE, 'Teacher 1', '1992-03-11'),
	('member-student1', 'member-student1', 'member-student', 1, TRUE, 'Student 1', '2005-11-09'),
	('member-student2', 'member-student2', 'member-student', 2, TRUE, 'Student 2', '2006-01-13'),
	('member-student3', 'member-student3', 'member-student', 3, FALSE, 'Student 3', '2006-07-13')
;

INSERT INTO authors
	(author)
VALUES
	('Untalented John')
;