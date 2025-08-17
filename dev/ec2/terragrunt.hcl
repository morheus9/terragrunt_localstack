terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//.?ref=v6.0.2"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path                             = "../vpc/"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "terragrunt-info", "show"]
  mock_outputs = {
    public_subnets = ["subnet-12345678"]
  }
}

dependency "sg" {
  config_path                             = "../sg/"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "apply", "destroy", "terragrunt-info", "show"]
  mock_outputs = {
    sg_id = "sg-abcdef12"
  }
}

inputs = {
  name                   = "${include.root.inputs.deployment_prefix}-bastion-host"
  instance_type          = "t3.micro"
  ami                    = "ami-08bdc08970fcbd34a"
  vpc_security_group_ids = [dependency.sg.outputs.sg_id]
  subnet_id              = dependency.vpc.outputs.public_subnets[0]
  tags = {
    Name = "${include.root.locals.deployment_prefix}-bastion-host"
  }

  # Correct format - use empty map instead of empty list
  network_interface = {}
}
