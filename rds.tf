module "rds_security_group" {
  source  = "github.com/terraform-aws-modules/terraform-aws-security-group"

  name        = local.name
  description = "MySQL SG"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

}


data "aws_ssm_parameter" "rds_username" {
  name = "rds_username"
}

data "aws_ssm_parameter" "rds_passwd" {
  name = "rds_passwd"
}



module "db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds/"

  identifier = local.name

  engine               = "mysql"
  engine_version       = "8.0.20"
  family               = "mysql8.0" 
  major_engine_version = "8.0"      
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  kms_key_id        = module.kms_key.key_arn

  name     = "completeMysql"
  username = data.aws_ssm_parameter.rds_username.value
  password = data.aws_ssm_parameter.rds_passwd.value
  port     = 3306

  multi_az               = true
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.rds_security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

 

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = {
    Name = "completeMysql"
  }
}


module kms_key {
  source = "github.com/terraform-module/terraform-aws-kms.git?ref=v2.0.0"

  alias_name              = "key"
  description             = "Key to encrypt and decrypt the database"

}

module "db_default" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds/"

  identifier = "${local.name}-default"

  create_db_option_group    = false
  create_db_parameter_group = false

  engine               = "mysql"
  engine_version       = "8.0.20"
  family               = "mysql8.0"
  major_engine_version = "8.0"      
  instance_class       = "db.t3.large"

  allocated_storage = 20

  name                   = "completeMysql"
  username               = "complete_mysql"
  create_random_password = true
  random_password_length = 12
  port                   = 3306

  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.rds_security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = {
    Name = "completeMysql"
  }
}

module "db_disabled" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds/"

  identifier = "${local.name}-disabled"

  create_db_instance        = false
  create_db_subnet_group    = false
  create_db_parameter_group = false
  create_db_option_group    = false
}