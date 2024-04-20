# Terraform-ec2-Flask
Simple Terraform code to deploy a Flask application on an EC2 instance. The Flask application connects to a MySQL database also deployed on the same EC2 instance.

## Prerequisites
- Terraform
- AWS Account
- AWS CLI (configure with AMI user, usinf access key and secret key)
### Not necessary but recommended
- Key pair to SSH into the EC2 instance

## Security advice
- Instead of hardcoding the database password in the code, you may wnat to set the sensitive data as an environment variable on your system and access it like: '${var.db_password}'
- Environment variables for terraform shoud be named like: TF_VAR_db_password (TF_VAR_ + variable name)

## Possible improvements

- It is woth to note that "provisioner" blocks are not the best way to configure the files on the EC2 instance. Using user_data with Remote File URLs will be implemented in the future. Even better, using a configuration management tool like Ansible will be a better approach.