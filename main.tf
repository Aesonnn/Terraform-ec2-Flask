terraform {
    required_providers {
        aws = {
        version = "> 5.31.0"
        }
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "ter_gr" {
    name = "terraform-example"
    description = "Used in the terraform"
    
    dynamic "ingress" {
        for_each = ["22", "80", "443", "5000"]
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
      
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform-example"
    }
}

# Adds the configuration data to the instance
# specifiying the db password by adding it to the template.
# db_password is specified on the local machine as an environment variable
# and is then passed to the template, which is then rendered and passed to the instance.
data "template_file" "init_script" {
    template = file("setup_flask.tpl")

    vars = {
        db_password = var.db_password
    }
}

resource "aws_instance" "app" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    key_name      = "MainPersonal"

    root_block_device {
        volume_size = 30
        volume_type = "gp3"
    }

    # rendering the template and passing it to the instance
    user_data = data.template_file.init_script.rendered

    tags = {
        Name = "FlaskAppInstance"
    }
    vpc_security_group_ids = [aws_security_group.ter_gr.id]
    security_groups = [aws_security_group.ter_gr.name]
}



