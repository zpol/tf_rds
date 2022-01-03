# tf-aws-tfstate-s3-dynamodb

## Overview

Terraform module to manage the Terraform tfstate file using an AWS S3 bucket and a DynamoDB table.

This module generates two resources:

* An S3 bucket to store the Terraform tfstate file.
* A DynamoDB table used for locking the Terraform tfstate file.

## Naming

The name of the resources depends on the input variables passed to the
module. The only mandatory variable is the `project_name`.

The format would be:

```
terraform-${project_name}[-${environment}][-${region}]
```

where `environment` and `region` are optional.

## Usage

This is just another Terraform module and should be used like that.

```hcl
module "tfstate" {
  source = "./modules/tf-aws-tfstate-s3-dynamodb"

  project_name = "demo"
  environment  = "dev"

  tags = module.label.tags
}

# S3 bucket: terraform-demo-dev-tfstate
# DynamoDB: terraform-demo-dev-tfstate-lock
```

Two use cases can be distinguish and are worth to mention:

* Existent projects, that already have an S3 bucket or DynamoDB table
* New projects, that needs to create a new S3 bucket or DynamoDB table

### Existent project

If this is the case and the S3 bucket or the DynamoDB table is already
created you need to make sure your resource names follow the naming
convention described above.

1. Define the module in Terraform
2. Import the existent resources into your tfstate file
3. Run a `ŧerraform plan` to check if everything is in place. It may try
to apply encryption or versioning if you are not already using it
4. Check the backend configuration in the terraform block

### New project

1. Define the module in Terraform
2. Make sure that you don't have any backend configuration in the terraform block
3. Run `terraform apply` to create the resources
4. Configure the [backend](https://www.terraform.io/docs/backends/types/s3.html) using the created resources.
5. Initialize Terraform with the new backend configuration (should ask to
move the tfsate to the new location)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| s3_bucket_name | The name of the S3 bucket used to store the tfstate file. If not assigned, a name will be composed using `s3_bucket_name_prefix` + `project_name` + `environment` + `region` + `s3_bucket_name_suffix` | string | `` | no
| s3_bucket_name_prefix | The prefix for the S3 bucket name in case `s3_bucket_name` is not set. | string | `terraform` | no
| s3_bucket_name_suffix | The suffix for the S3 bucket name in case `s3_bucket_name` is not set. | string | `tfstate` | no
| acl | The canned ACL to apply to the S3 bucket | string | `private` | no |
| append_region_to_name | Whether to add the region to the bucket and DynamoDB names | string | `false` | no |
| environment | The Name of the Environment. If not empty will be appended to the bucket and DynamoDB names | string | `` | no |
| force_destroy | A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable | string | `false` | no |
| mfa_delete | A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 ) | string | `false` | no |
| project_name | The Name of the Project | string | - | yes |
| read_capacity | DynamoDB read capacity units | string | `2` | no |
| region | If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee | string | `` | no |
| tags | A mapping of tags to assign to the resources | map | - | yes |
| write_capacity | DynamoDB write capacity units | string | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb_table_arn | DynamoDB table ARN |
| dynamodb_table_id | DynamoDB table ID |
| dynamodb_table_name | DynamoDB table name |
| s3_bucket_arn | S3 bucket ARN |
| s3_bucket_domain_name | S3 bucket domain name |
| s3_bucket_id | S3 bucket ID |
