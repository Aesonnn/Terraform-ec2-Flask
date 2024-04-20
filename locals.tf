locals {
  user_data = <<-EOF
            #!/bin/bash
            sudo apt update
            sudo apt install -y python3-pip python3-dev mysql-server
            sudo systemctl start mysql
            sudo mysql -e "CREATE DATABASE flaskdb;"
            sudo mysql -e "CREATE USER 'flaskuser'@'localhost' IDENTIFIED BY 'yourpassword';"
            sudo mysql -e "GRANT ALL PRIVILEGES ON flaskdb.* TO 'flaskuser'@'localhost';"
            sudo mysql -e "FLUSH PRIVILEGES;"
            # Create the users table in the flaskdb database
            sudo mysql -e "CREATE TABLE flaskdb.users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL);" 
            sudo pip3 install flask mysql-connector-python
            cd /home/ubuntu

            cat > app.py << 'END'
            from flask import Flask, request, render_template, redirect, url_for
            import mysql.connector

            app = Flask(__name__)

            db_config = {
                'host': 'localhost',
                'user': 'flaskuser',
                'password': 'yourpassword',
                'database': 'flaskdb'
            }

            @app.route('/', methods=['GET', 'POST'])
            def register():
                if request.method == 'POST':
                    username = request.form['username']
                    email = request.form['email']
                    conn = mysql.connector.connect(**db_config)
                    cursor = conn.cursor()
                    cursor.execute("INSERT INTO users (username, email) VALUES (%s, %s)", (username, email))
                    conn.commit()
                    cursor.close()
                    conn.close()
                    return redirect(url_for('register'))
                return render_template('register.html')

            if __name__ == '__main__':
                app.run(host='0.0.0.0', port=5000)
            END

            mkdir templates
            cat > templates/register.html << 'END'
            <!DOCTYPE html>
            <html>
            <head>
                <title>Register</title>
            </head>
            <body>
                <form action="/" method="post">
                    Username: <input type="text" name="username"><br>
                    Email: <input type="email" name="email"><br>
                    <input type="submit" value="Register">
                </form>
            </body>
            </html>
            END
            FLASK_APP=app.py flask run --host=0.0.0.0
            EOF
}

# locals {
#   user_data = <<-EOF
#             #!/bin/bash
#             sudo apt update
#             sudo apt install -y python3-pip python3-dev mysql-server
#             sudo systemctl start mysql
#             sudo mysql -e "CREATE DATABASE flaskdb;"
#             sudo mysql -e "CREATE USER 'flaskuser'@'localhost' IDENTIFIED BY 'yourpassword';"
#             sudo mysql -e "GRANT ALL PRIVILEGES ON flaskdb.* TO 'flaskuser'@'localhost';"
#             sudo mysql -e "FLUSH PRIVILEGES;"
#             # Create the users table in the flaskdb database
#             sudo mysql -e "CREATE TABLE flaskdb.users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL);" 
#             sudo pip3 install flask mysql-connector-python
#             cd /home/ubuntu

#             FLASK_APP=app.py flask run --host=0.0.0.0
#             EOF
# }

