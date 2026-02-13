# Deploy Locust performance test environment

## Create Infrastructure

Be sure that AWS CLI and jq is installed on your computer.

Log in to the AWS account with your own user that has admin privileges via the AWS CLI or simply set the necessary environment variables.

Execute the following commands. This run will create the S3 state buckets and necessary IAM users, roles and permissions.

```bash
cd aws/global/single-account-bootstrap

terragrunt init

terragrunt plan

# If the plan has runned successfully, run an apply to create the resources
terragrunt apply
```

After it has created all the resources,  uncomment the include "root" section at the aws/global/single-account-bootstrap/terragrunt.hcl file.
L31-33

```hcl
# include "root" {
#   path = find_in_parent_folders("global.hcl")
# }
```

and comment out the remote_state block at the aws/global/single-account-bootstrap/terragrunt.hcl file.

```hcl
# remote_state {
#   backend = "local"
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite"
#   }
#   config = {
#     path = "${get_terragrunt_dir()}/terraform.tfstate"
#   }
# }
```

Create an access key for the terraform-deployer-user because we'll use this user for further steps.

```bash
if [ ! -f ~/tf-deployer-user-access-key.json ]; then
  aws iam create-access-key --user-name terraform-deployer-user > ~/tf-deployer-user-access-key.json
else
  echo "Won't create new access key because one has already created"
fi && \
unset AWS_ACCESS_KEY_ID && \
unset AWS_SECRET_ACCESS_KEY && \
unset AWS_SESSION_TOKEN && \
unset AWS_PROFILE && \
export AWS_ACCESS_KEY_ID=$(jq -r '.AccessKey.AccessKeyId'  ~/tf-deployer-user-access-key.json) && \
export AWS_SECRET_ACCESS_KEY=$(jq -r '.AccessKey.SecretAccessKey'  ~/tf-deployer-user-access-key.json)
```

Then run the migrate state command:

```bash
terragrunt init -migrate-state
```

Check the network configurations and validate CIDR block of the VPC and the subnets whether it meets your needs.

If the state migration was successful and the network addresses are fine, run the following terragrunt command to deploy the whole infrastructure:

!NOTE - You have to be in the aws folder where the root.hcl file exists.

```bash
terragrunt run --all --filter './**/**/**/network' -- apply
terragrunt run --all --filter '!./global/**' -- apply
```

## Delete Infrastructure

```bash
terragrunt run --all --filter '!./global/**' -- destroy
```

Uncomment the local backend configuration at aws/global/single-account-bootstrap/terragrunt.hcl and migrate the actual state to the local backend

```hcl
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}
```

```bash
terragrunt init -migrate-state
```

Comment out include root block at aws/global/single-account-bootstrap/terragrunt.hcl

```bash
# include "root" {
#   path = find_in_parent_folders("global.hcl")
# }
```

Set the "force_destroy" variable to true to be able to destroy the state bucket. To enable that, run an apply.

```bash
terragunt apply
```

After force destroy is enabled, you can delete the IAM user, roles, and state buckets to erase the whole infrastucture.

```bash
cd aws/global/single-account-bootstrap
terragrunt destroy
```

## Remove cache files

```bash
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} + && \
find . -type f -name ".terraform.lock.hcl" -prune -exec rm {} +
```

## How to access Locust UI

For this purpose we use SSM with AWS-StartPortForwardingSession SSM document. That way we do not have to implement ALB and deal with DNS zones, records and certificates. SSM is already encrypted on HTTPS.

```bash
aws ssm start-session \
--target "<master_host_instance_id>" \
--region eu-central-1 \
--document-name AWS-StartPortForwardingSession \
--parameters '{"portNumber":["8089"], "localPortNumber":["8089"]}'
```
