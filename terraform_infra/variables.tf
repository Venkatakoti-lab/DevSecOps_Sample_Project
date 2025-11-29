variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "key_name" {
  type    = string
  default = "yadav"
}
variable "ingress" {
  default = [
    {
      description = "Allow from Personal CIDR block"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow SSH from Personal CIDR block"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}