provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "ghostubuntu_sg" {
  name        = "GhostUbuntuSecurityGroup"
  description = "Security group for Ghost Ubuntu Server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ghostubuntu" {
  ami           = "ami-06dd92ecc74fdfb36"  # Remember to replace this with the appropriate AMI for your region.
  instance_type = "t2.micro"
  key_name      = "e570"  # Replace with the name of your existing key.
  vpc_security_group_ids = [aws_security_group.ghostubuntu_sg.id]

user_data = <<-EOT
              #!/bin/bash
              apt-get update
              apt-get install -y curl
              
              # Download the setup script from GitHub
              curl -o /tmp/setup.sh https://raw.githubusercontent.com/flakkv/ghost-ubuntu/master/setup.sh

              # Make the script executable
              chmod +x /tmp/setup.sh

              # Execute the script
              /tmp/setup.sh
  EOT


  tags = {
    Name = "GhostUbuntuServer"
  }
}

output "ghostubuntu_ip" {
  value = aws_instance.ghostubuntu.public_ip
}
