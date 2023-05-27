from website import create_app
from flask_mysqldb import MySQL

app = create_app()

# mysql = MySQL(app)

if __name__ == '__main__': # needed so that the app does not run when imported
    app.run(debug=True, host='localhost', port=5000) # debug needed for reruning the server when we make code changes

# from flask import Flask, render_template, request
# from flask_mysqldb import MySQL
 
# app = Flask(__name__)
 
# app.config['MYSQL_HOST'] = 'localhost'
# app.config['MYSQL_USER'] = 'root'
# app.config['MYSQL_PASSWORD'] = 'my_root_password'
# # I need to use an entire schema so do not select any db!
# # app.config['MYSQL_DB'] = 'flask'
# # no need to configure the port because it is located in 3306
# # this port is the port usually selected by MYSQL databases
 
# mysql = MySQL(app)

# with app.app_context():
#     #Creating a connection cursor
#     cursor = mysql.connection.cursor()

#     cursor.execute('''
#         DROP SCHEMA IF EXISTS flask;
#         CREATE SCHEMA flask;
#         USE flask;
#     ''')
    
#     #Executing SQL Statements
#     cursor.execute('''
#         CREATE TABLE school_unit (
#             school_id INT AUTO_INCREMENT,
#             school_name VARCHAR(60),
#             school_address VARCHAR(60),
#             PRIMARY KEY (school_id)
#         );
#     ''')

#     cursor.execute('''
#         INSERT INTO school_unit
#             (school_name, school_address)
#         VALUES
#             ('Evangeliki', 'Themistkli Sofouli')
#         ;
#     ''')

#     #cursor.execute(''' DELETE FROM table_name WHERE condition ''')
    
#     #Saving the Actions performed on the DB
#     mysql.connection.commit()
    
#     #Closing the cursor
#     cursor.close()



# @app.route('/form')
# def form():
#     return render_template('form.html')
 
# @app.route('/login', methods = ['POST', 'GET'])
# def login():
#     if request.method == 'GET':
#         return "Login via the login Form"
     
#     if request.method == 'POST':
#         school = request.form['school']
#         address = request.form['address']
#         cursor = mysql.connection.cursor()
#         cursor.execute(''' INSERT INTO school_unit VALUES(%s,%s)''',(school,address))
#         mysql.connection.commit()
#         cursor.close()
#         return f"Done!!"

# if __name__ == '__main__': # needed so that the app does not run when imported
#     app.run(debug=True, host='localhost', port=5000) # debug needed for live changes without resetting the server