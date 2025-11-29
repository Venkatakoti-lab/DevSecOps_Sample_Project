resource "aws_instance" "web" {
  ami                  = data.aws_ami.ami_id.id
  instance_type        = "t2.medium"
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  security_groups      = [aws_security_group.jenkins_sg.id]
  user_data            = file("jenkins.sh")
  tags = {
    Name = "Jenkins"
  }
  root_block_device {
    volume_size = 30

  }
}
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow Jenkins Traffic"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = ingress.value[description]
      from_port   = ingress.value[from_port]
      to_port     = ingress.value[to_port]
      protocol    = ingress.value[protocol]
      cidr_blocks = ingress.value[cidr_blocks]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Jenkins SG"
  }
}



resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
     }
  ]
}
EOF
}



