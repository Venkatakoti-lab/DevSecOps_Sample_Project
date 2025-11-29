output "instance_ips" {
  value = {
    public_ip  = aws_instance.web.public_ip,
    private_ip = aws_instance.web.private_ip
  }
}
output "ami_info" {
  value = data.aws_ami.ami_id.id
}
output "default_vpc_id" {
  value = data.aws_vpc.default.id
}
