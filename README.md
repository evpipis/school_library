# school_library

## Installation (for windows)

* Make sure you have installed MySQL Workbench and Visual Studio Code.

### Run the following sql queries inside the DMBS (at this specific order !).

* CREATE_tables.sql (SQL_Code) to create the database and the tables.
* INSERT_mock_data.sql (SQL_Code) to insert some mock data for testing purposes.
* QUERY_operations.sql (SQL_Code) to load the sql queries for this project.
* backup-4-6.sql (Mock_Data) to load some initial mock data.

### Download and run the web application

* Run

      $ git clone https://github.com/evpipis/school_library.git
      $ cd school-library

* Create config.py file in website folder and add the following credentials, for example,

      secret_key = 'some random string'
      mysql_host = 'localhost'
      mysql_user = 'root'
      mysql_password = 'your_root_password'
      mysql_db = 'SchoolLibrary'
      mysql_exe_path = "\"" + r"D:\Program Files\MySQL\MySQL Server 8.0\bin\mysql" + "\""
      mysqldump_exe_path = "\"" + r"D:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump" + "\""
      backup_file_path = "\"" + r".\backups\backup.sql" + "\""
      
* Run the following script to download all required libraries,

      $ pip install -r requirements.txt
      
* Run the following script to enter the Project folder and start the web-server (in development mode),

      $ cd Project
      $ flask --app main run --debug
      
* Open your browser and type http://127.0.0.1:5000/ to preview the website.
