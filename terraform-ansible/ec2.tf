# key pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-ansible-key"
  public_key = file("terra-ansible-key.pub")
}

# vpc & Security group 
resource "aws_default_vpc" "default" {

}


# security 
resource "aws_security_group" "my_security_group" {
  name        = "ansible-automate"
  description = "this will add a TF generated Security group"
  vpc_id      = aws_default_vpc.default.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https open"
  }


}

# aws_instance 

resource "aws_instance" "my_instance" {
  for_each = tomap({
    ansible_master = "ami-0aba19e56f3eaec05" #ubuntu
    ansible_node1  = "ami-0aba19e56f3eaec05" #ubuntu
    ansible_node2  = "ami-07ba4be829b9bf20a" #redhat
    ansible_node3  = "ami-06cfeaaa22092f09d" #amazon
  })
  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]

  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  
  instance_type   = "t3.micro"
  ami             = each.value
  root_block_device {
    volume_size = 15
    volume_type = "gp3"

  }
  tags = {
    Name = each.key
  }
}