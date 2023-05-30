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
