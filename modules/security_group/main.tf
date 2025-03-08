resource "aws_security_group" "hadoop_security_group" {
  name        = "hadoop_security_group"
  description = "Security group for Hadoop instance"
  vpc_id      = var.vpc_id

  # Allow all inbound TCP traffic (be cautious about using this)
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH traffic
  ingress {
    from_port = 22   # SSH
    to_port  = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optionally, add egress rules if necessary
  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"  # Allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
  value = aws_security_group.hadoop_security_group.id
}
