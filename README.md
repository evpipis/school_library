# school_library

## Installation (for windows)

* Make sure you have installed MySQL Workbench and Visual Studio Code.

### Run the following sql queries inside the DMBS (at this spesific order !).

* CREATE_tables.sql to create the database and the tables.
* INSERT_mock_data.sql to insert some mock data for testing purposes.

### Download and run the web application

* Run

      $ git clone https://github.com/evpipis/school_library.git
      $ cd hotel-management

* Create config.py file in website folder and add the following credentials,

      secret_key = 'some random string'
      mysql_host = 'localhost'
      mysql_user = 'root'
      mysql_password = 'your root password'
      mysql_db = 'SchoolLibrary'
      
* Run the following script to download all required libraries,

      $ pip install -r requirements.txt
      
* Run the following script to enter the Project folder and start the web-server (in development mode),

      $ cd Project
      $ flask --app main run --debug
      
* Open your browser and type http://127.0.0.1:5000/ to preview the website.
