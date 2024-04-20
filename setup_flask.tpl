#!/bin/bash

# Export the DB_PASSWORD environment variable (temporary) Probably, enough that it works :)
export DB_PASSWORD="${db_password}"

# Update system and install necessary packages
sudo apt update
sudo apt install -y python3-pip python3-dev mysql-server

# Start MySQL and configure the database
sudo systemctl start mysql
sudo mysql -e "CREATE DATABASE flaskdb;"
sudo mysql -e "CREATE USER 'max'@'localhost' IDENTIFIED BY '${db_password}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON flaskdb.* TO 'max'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -e "CREATE TABLE flaskdb.users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL);"

# Install Python packages
sudo pip3 install flask mysql-connector-python

# Download the application files
cd /home/ubuntu
sudo curl -o app.py https://raw.githubusercontent.com/Kreonn1/flask-data/main/app.py
mkdir templates
sudo curl -o templates/register.html https://raw.githubusercontent.com/Kreonn1/flask-data/main/templates/register.html

# Make the app executable and run it
sudo chmod +x app.py
FLASK_APP=app.py flask run --host=0.0.0.0 &
sudo python3 app.py
