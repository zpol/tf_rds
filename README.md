# tf_rds
Terraform demo code to deploy:

* An RDS instance on a private subnet with access credentials stored on SSM Parameter Store + KMS Encryption
* An RDS Replica with the same features above.
* An EC2 instance with a Docker inside running Laravel Framework
* A VPC with some private and public subnets and all the related networking stuff ( Route tables, Routes, Internet Gateways and so on...)

## Usage

### Deploy the infra

* Get and AWS account
* Create a set of IAM access credentials
* Create 2 Parameters into SSM -> Parameter Store named: `rds_username` and `rds_passwd` with the proper values
* Clone this repository
* Load your access credentials
* If you already have Terraform installed just run: 

`terraform init && terraform apply`

The EC2 instance can be accessed from it's public IP address.
This value is printed as output when Terraform finishes.

### For destroying everything: 

`terraform destroy --auto-approve`
