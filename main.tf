# main.tf

module "security_group" {
  source = "./modules/security_group"
  vpc_id = "vpc-04dae2a3187f45703"
  # Pass any required variables here
}

# main.tf

module "ec2_instance" {
  source            = "./modules/ec2_instance"
  ami               = "ami-09c813fb71547fc4f"
  instance_type     = "t2.micro"
  subnet_id         = "subnet-083995b999421458a"
  security_group_id = module.security_group.id
  key_name          = "your-ssh-key"
  # iam_role          = "arn:aws:iam::794038224251:instance-profile/ec2-admin"
}
