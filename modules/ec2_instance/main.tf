resource "aws_instance" "hadoop_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = 1
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]
  # key_name        = var.key_name
  # Root volume size increase
  root_block_device {
    volume_size = 30  # Increase root volume size (example 40GB)
    volume_type = "gp2"
  }
  # Adding a new volume to increase space for /home
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 30  # This can be used for /home, ensure it's enough space
    volume_type = "gp2"
  }
  iam_instance_profile = "ec2-admin"
  tags = {
    Name = "Hadoop_Instance"
  }

  # Provisioning Java installation using local-exec
  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' -e ansible_user=ec2-user -e ansible_password=DevOps321 install_java.yaml"
  }
}

# Null resource to run the resize playbook after EC2 instance creation
resource "null_resource" "resize" {
  depends_on = [aws_instance.hadoop_instance]  # Ensure this runs after instance creation

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.hadoop_instance[0].public_ip},' -e ansible_user=ec2-user -e ansible_password=DevOps321 resize.yaml"
  }
}

output "public_ip" {
  value = aws_instance.hadoop_instance[0].public_ip
}
