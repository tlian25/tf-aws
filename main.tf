provider "aws" {
  region     = "us-east-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
            #!/bin/bash 
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p ${var.SERVER_PORT} &
            EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    ingress {
        from_port = var.SERVER_PORT
        to_port = var.SERVER_PORT
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_ip" {
    description = "The public IP of the web server"
    value = aws_instance.example.public_ip
}