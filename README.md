# Terraform-ec2-Flask
Simple Terraform code to deploy a Flask application on an EC2 instance. The Flask application connects to a MySQL database also deployed on the same EC2 instance.

## Prerequisites
- Terraform
- AWS Account
- AWS CLI (configure with AMI user, using access key and secret key)
### Not necessary but recommended
- Key pair to SSH into the EC2 instance

## Security advice
- Instead of hardcoding the database password in the code, you may want to set the sensitive data as an environment variable on your system and access it like: '${var.db_password}'
- Environment variables for terraform shoud be named like: TF_VAR_db_password (TF_VAR_ + variable name)

## What this code does
- The code creates an EC2 instance and the security group to allow traffic on different ports, but the one we are interested in is port 5000 (Flask default port)
- The `setup_flask.tpl` template configures the packages necessary to run the Flask application and the MySQL database. The database password is specified on the local machine as an environment variable and is then passed to the template. The final script is generated from the template and eventually is passed to the instance. Data entered on the web page is stored in the MySQL database.

- `user_data` uses Remote File URLs to download the files from the remote repository. The files are then executed on the instance.
- Specifically, files for the Flask application are loaded using the `curl` command. The files stored in the remote repository are downloaded to the instance. The Flask application is then started.

## Possible improvements

- Using user_data with Remote File URLs to download files to the instance is not a bad option. However, using a configuration management tool like Ansible is a much better approach which will be implemented in the future.
