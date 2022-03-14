# Create EC2 Instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "my-ec2-vm" {
  ami                    = var.ec2_ami_id
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "terraform-key"
  count = var.ec2_instance_count
  vpc_security_group_ids = [aws_security_group.vpc-web-sg.id,aws_security_group.vpc-ssh-sg.id ]
  user_data              = <<-EOF
    #! /bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo service httpd start
    sudo systemctl enable httpd
    echo "<h1> Welcome eliarms" > /var/www/html/index.html

  EOF

  tags = {
    "Name" = "web"
     
  }
}