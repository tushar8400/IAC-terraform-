# key pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# vpc & Security Group
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "automate_sg"
  description = "this will add terraform generated Security group"
  vpc_id      = aws_default_vpc.default.id


  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open terraform"

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open terraform"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https open from terraform"
  }

  # outbound rules 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"

  }
}
# ec2 instance

resource "aws_instance" "my_instance" {
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]

  instance_type = var.aws_instance_type
  ami           = var.ec2_ami_id
  user_data = file("install_nginx.sh")


  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }

  tags = {
     Name = "Tushar-terraform" 
  }
}
