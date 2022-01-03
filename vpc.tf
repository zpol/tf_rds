module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc/"

  name = "demo-interview"
  cidr = "10.10.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "demo"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "demo-interview"
  }
}

