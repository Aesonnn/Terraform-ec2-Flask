locals {
  user_data = <<-EOF
            #!/bin/bash
            sudo echo "export DB_PASSWORD='${var.db_password}'" >> /etc/environment
            sudo apt update
            sudo apt install -y python3-pip python3-dev mysql-server
            sudo systemctl start mysql
            sudo mysql -e "CREATE DATABASE flaskdb;"
            sudo mysql -e "CREATE USER 'max'@'localhost' IDENTIFIED BY '${var.db_password}';"
            sudo mysql -e "GRANT ALL PRIVILEGES ON flaskdb.* TO 'max'@'localhost';"
            sudo mysql -e "FLUSH PRIVILEGES;"
            # Create the users table in the flaskdb database
            sudo mysql -e "CREATE TABLE flaskdb.users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL);" 
            sudo pip3 install flask mysql-connector-python
            cd /home/ubuntu
            FLASK_APP=app.py flask run --host=0.0.0.0
            sudo python3 app.py
            EOF
}

variable "db_password" {
  description = "The database password for MySQL"
  type        = string
  sensitive   = true
}