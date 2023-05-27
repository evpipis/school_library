DROP SCHEMA IF EXISTS SchoolLibrary;
CREATE SCHEMA SchoolLibrary;
USE SchoolLibrary;

-- PUT NOT NULL IN MANDATORY FIELDS
CREATE TABLE school_unit
(
	id INT AUTO_INCREMENT, -- SUPPOSE THIS IS NOT NULL
		PRIMARY KEY(id),
	name VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	phone CHAR(10),
	email VARCHAR(50) UNIQUE, 
	principal_name VARCHAR(50)
    -- manager_name VARCHAR(60) -- this should be a list of names actually!
	-- schoolLibAdminId INT, 
	-- PRIMARY KEY(id)
);

-- assumptions:
-- each user has one specific role
-- later I will update it so that many one user
-- can have multiple roles and in different schools.
-- Only consistent tuples are (admin, NULL, active) or (other_user, school_id, active/inactive)
-- should i change NULL school_id with something else? No
CREATE TABLE user
(
	id INT AUTO_INCREMENT,
		PRIMARY KEY(id),
    username VARCHAR(30) UNIQUE NOT NULL, -- shouldn't this be the primary key? for now you can keep id
    password VARCHAR(30) NOT NULL,
    role ENUM('admin', 'manager', 'member-teacher', 'member-student') NOT NULL,
    school_id INT,
		FOREIGN KEY(school_id) REFERENCES school_unit(id),
    is_active BOOL NOT NULL
);


