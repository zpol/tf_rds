module "tfstate" {
  source = "./modules/tf-aws-tfstate-s3-dynamodb"

  project_name = "tfstate-demo"
  environment  = "demo"
  access_logs_bucket_name = "tfstate-demo-access-logs"

  tags = {
    Owner = "demo"
    Name  = "demo"  
    }
}

# create s3 bucket for storing logs
resource "aws_s3_bucket" "access_logs" {
  bucket = "tfstate-demo-access-logs"
  acl    = "private"
}