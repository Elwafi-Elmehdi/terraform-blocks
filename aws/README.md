# AWS

AWS or Amazon Web Services is a major cloud provider

## Provider

The default provider is `hashicorp/aws`

-   [Source Code](https://github.com/hashicorp/terraform-provider-aws)
-   [Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest)

## Projects

| Provider | Projects                                                             | Description                                                                                     | Resources                                                                                                                      |
| -------- | -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| AWS      | [Simple Web Server](./1-web-server/)                                 | a public web server deployed in the default VPC, running on a EC2 instance                      | `aws_instance`,`aws_security_group`                                                                                            |
| AWS      | [Private server behind a NAT, with a jumpbox](./2-nated-web-server/) | private server behind a nat, more secured access through a bastian host with a fixed Public IP. | 2 x `aws_instance`, 2 x `aws_security_group`, `aws_eip`, `aws_nat_gateway`                                                     |
| AWS      | [scalable and highly available vpc](./3-scalable-vpc/)               | deploy a vpc with 2 private subnets and 2 public subnets in which an ec2 instance is deployed   | `aws_vpc`, `aws_internet_gateway`, 4x `aws_subnet`, 2x `aws_route_table`, `aws_security_group`, `aws_key_pair`, `aws_instance` |

## FAQs

### How to securely pass AWS credentials to Terraform ?

You can pass AWS credentials, as Environment variables or store them in `$HOME/.aws/credentials` for Linux, and `"%USERPROFILE%\.aws\config` for MacOS and `%USERPROFILE%\.aws\credentials` on Windows.

#### Environment Variables

You can pass credentials using envs, note that the envs will only be define in the current shell session, if you exit your shell you would repeat the process below

```shell
$ export AWS_ACCESS_KEY_ID="awsaccesskey"
$ export AWS_SECRET_ACCESS_KEY="awssecretkey"
```

#### Credentials File

in your aws credentials file `$HOME/.aws/credentials`

```ini
[default]
aws_access_key_id = awsaccesskey
aws_secret_access_key = awssecretkey
```

### I cant see Terraform provisioned resources on Web Console.

The default region is `us-east-1`, switch your web console to `us-east-1`.

### How to change default AWS region?

The default region is `us-east-1`, You can switch in terraform HCL configuration

```hcl
provider "aws" {
    region = "eu-west-1"
}
```

or with environment variables

```shell
$ export AWS_REGION="eu-west-3"
```

### Getting `an error occurred (Authfailure) when calling the describeinstances operation`

This is caused either by an expired secret token or non synced time between your machine and aws servers.

#### Sync Your machine time with AWS servers

```shell
$ date
$ sudo service ntpd stop
$ sudo ntpdate time.nist.gov
$ sudo service ntpd start
$ ntpstat
```
