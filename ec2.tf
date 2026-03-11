#key pair
resource aws_key_pair my_key {
  key_name = "${var.env}-terraform-ec2-key"
  public_key= file("terraform-ec2-key.pub")
  tags = {
    Environment=var.env
  }
}


#VPC & Security Groups

resource aws_default_vpc default {

}

resource aws_security_group my_security_group {
  
name= "${var.env}-automate-sg"
description = "this will add a TF generated security group"
vpc_id = aws_default_vpc.default.id # interpolation
# inbound rules
ingress{
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
description = "SSH open"
}

ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
}
# outbound rules
egress{
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
description = "all access open outbound"
}

tags = {
  Name= "${var.env}-automate-sg"
  Environment=var.env
}

}

# ec2 instance
resource "aws_instance" "my_instance" {
  for_each = tomap({
    "pratik_micro_1"="t3.small",
    "pratik_micro_2"="t3.small"

  })

  ami                    = var.ec2_ami_id
  instance_type          = each.value
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data = file("install_nginx.sh")
  root_block_device {
    volume_size = var.env=="prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
    Environment=var.env
  }
}