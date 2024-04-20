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

resource "aws_instance" "app" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"

    root_block_device {
        volume_size = 30 
        volume_type = "gp3"
    }

    # provisioner "file" {
    #     source      = "E:/Code/TerraformFlask/app.py"
    #     destination = "/home/ubuntu/app.py"
    # }

    # provisioner "file" {
    #     source      = "E:/Code/TerraformFlask/templates"
    #     destination = "/home/ubuntu/templates"
    # }

    # connection {
    #     type        = "ssh"
    #     user        = "ubuntu"
    #     private_key = file("${var.private_key_path}")
    #     host        = self.public_ip
    # }

    # Ensure the server is up before running provisioners
    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo systemctl restart flaskapp.service"
    #     ]
    # }

    user_data = local.user_data

    tags = {
        Name = "FlaskAppInstance"
    }
    vpc_security_group_ids = [aws_security_group.ter_gr.id]
    security_groups = [aws_security_group.ter_gr.name]
}


