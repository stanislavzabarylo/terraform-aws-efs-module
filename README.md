<!-- BEGIN_TF_DOCS -->
# AWS Elastic File System Module

## Usage

Here is an example HCL code snippet that demonstrates how to use AWS EFS Terraform module:

```hcl
module "efs" {
  source = "../.."

  # Basic EFS configuration
  name                            = "example-elastic-file-system"
  creation_token                  = "example-creation-token"
  encrypted                       = true
  enable_automatic_backups        = true
  kms_key_id                      = "example-kms-key-id"
  performance_mode                = "generalPurpose"
  throughput_mode                 = "provisioned"
  provisioned_throughput_in_mibps = 100

  # Lifecycle management
  lifecycle_policy = {
    transition_to_ia                    = "AFTER_7_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  # Access points
  access_points = {
    example_posix_user = {
      ac_name = "example-posix-user"
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002, 1003, 1004]
      }
      root_directory = {
        path = "/example-posix-user"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  # Security Group Configuration for EFS Mount Targets
  security_group_configuration = {
    description = "Security group for EFS mount targets"
    name_prefix = "efs-"
    vpc_id      = "vpc-1234567890"

    # Ingress rules are automatically configured for EFS port 2049
    ingress_rules = {
      allow_vpc = {
        description = "Allow NFS access from VPC"
        cidr_blocks = ["10.0.0.0/16"]
      }
      allow_specific_sg = {
        description              = "Allow NFS from specific security group"
        source_security_group_id = "example-sg-0"
      }
    }

    # Configurable egress rules
    egress_rules = {
      allow_all = {
        description = "Allow all outbound traffic"
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
  
  # Mount targets in multiple AZs
  mount_targets = [
    {
      subnet_id       = "example-subnet-id-1"
      security_groups = ["example-sg-id-1", "example-sg-id-2"]
      timeouts = {
        create = "50m"
        delete = "40m"
      }
    },
    {
      subnet_id       = "example-subnet-id-2"
      security_groups = ["example-sg-id-3", "example-sg-id-4"]
      timeouts = {
        create = "40m"
        delete = "30m"
      }
    }
  ]

  # Cross-region replication
  replication_configuration = {
    region                 = "us-east-1"
    availability_zone_name = "us-east-1a"
    timeouts = {
      create = "1h"
      delete = "30m"
    }
  }

  # File System IAM policy
  policy_configuration = {
    version   = "2012-10-17"
    policy_id = "example-policy-id"
    statements = [
      {
        sid = "example-sid"
        actions = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ]
        principals = [
          {
            type        = "AWS"
            identifiers = ["arn:aws:iam::111122223333:role/ExampleEFSRole"]
          }
        ]
      }
    ]
    bypass_policy_lockout_safety_check = false
  }

  tags = {
    CreatedBy = "Terraform"
  }
}
```

## Examples

[`Examples`](https://github.com/stasyk003/terraform-aws-efs-module/tree/main/examples) demonstrate use-cases and configurations of the module. They serve both as a reference for users implementing the module and as integration tests for validating module functionality.

- [Complete](https://github.com/stasyk003/terraform-aws-efs-module/tree/main/examples/complete)
- [Default](https://github.com/stasyk003/terraform-aws-efs-module/tree/main/examples/default)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.40 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_backup_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_file_system_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_efs_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_replication_configuration) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | A map of access points to create for the file system. Each access point supports the following settings:<br/><br/><ul><li>`name`</ul></li>: (Optional) A descriptive name for the access point.</ul></li><br/><br/><ul><br/>  <li>`posix_user`: (Optional) The operating system user and group applied to all file system requests made using the access point<br/>    <ul><br/>      <li>`gid`: (Required) The POSIX group ID used for all file system operations using this access point</li><br/>      <li>`secondary_gids`: (Optional) Secondary POSIX group IDs used for all file system operations using this access point</li><br/>      <li>`uid`: (Required) The POSIX user ID used for all file system operations using this access point</li><br/>    </ul><br/>  </li><br/></ul><br/><ul><br/>  <li>`root_directory`: (Optional) Configures the access point's root directory<br/>    <ul><br/>      <li>`path`: (Optional) The path on the EFS file system to expose as the root directory to NFS clients using the access point</li><br/>      <li>`creation_info`: (Optional) Specifies the POSIX IDs and permissions to apply to the access point's root directory<br/>        <ul><br/>          <li>`owner_gid`: (Required) The POSIX group ID to apply to the root directory</li><br/>          <li>`owner_uid`: (Required) The POSIX user ID to apply to the root directory</li><br/>          <li>`permissions`: (Required) The POSIX permissions to apply to the root directory, in numeric notation (e.g. `"0755"`)</li><br/>      </li><br/>    </ul><br/>  </li><br/></ul> | <pre>map(object({<br/>    name = optional(string)<br/>    posix_user = optional(object({<br/>      gid            = number<br/>      secondary_gids = optional(set(number))<br/>      uid            = number<br/>    }))<br/>    root_directory = optional(object({<br/>      path = optional(string)<br/>      creation_info = optional(object({<br/>        owner_gid   = number<br/>        owner_uid   = number<br/>        permissions = string<br/>      }))<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_availability_zone_name"></a> [availability\_zone\_name](#input\_availability\_zone\_name) | The AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes | `string` | `null` | no |
| <a name="input_creation_token"></a> [creation\_token](#input\_creation\_token) | A unique name used to ensure idempotent file system creation. <br/>If not specified, defaults to an auto-generated string combining timestamp and UUID in the format: <br/>`"terraform-<YYYYMMDDhhmmss>-<random_uuid>"` (defined as a local value in `main.tf` file) | `string` | `null` | no |
| <a name="input_enable_automatic_backups"></a> [enable\_automatic\_backups](#input\_enable\_automatic\_backups) | If `true`, automatic backups will be enabled for the file system. Defaults to `false` | `bool` | `false` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | If `true`, the disk will be encrypted. Defaults to `true` | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. When specifying `kms_key_id`, `encrypted` needs to be set to `true` | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | Configuration for EFS lifecycle policy transitions. Supports the following settings:<br/><br/><ul><li>`"transition_to_archive"`: (Optional) Indicates how long it takes to transition files to the Archive storage class. <br/>  Requires `"transition_to_ia"` to be specified, with `"performance_mode"` set to `"generalPurpose"` and `"throughput_mode"` set to `"elastic"`.<br/>  Valid values: `"AFTER_1_DAY"`, `"AFTER_7_DAYS"`, `"AFTER_14_DAYS"`, `"AFTER_30_DAYS"`, `"AFTER_60_DAYS"`, `"AFTER_90_DAYS"`, <br/>  `"AFTER_180_DAYS"`, `"AFTER_270_DAYS"`, `"AFTER_365_DAYS"`</ul></li><br/><br/><ul><li>`"transition_to_ia"`: (Optional) Indicates how long it takes to transition files to the IA storage class. <br/>  Valid values: `"AFTER_1_DAY"`, `"AFTER_7_DAYS"`, `"AFTER_14_DAYS"`, `"AFTER_30_DAYS"`, `"AFTER_60_DAYS"`, `"AFTER_90_DAYS"`, <br/>  `"AFTER_180_DAYS"`, `"AFTER_270_DAYS"`, `"AFTER_365_DAYS"`</ul></li><br/><br/><ul><li>`"transition_to_primary_storage_class"`: (Optional) Indicates how long it takes to transition files back to <br/>  the primary storage class. Only valid value is `"AFTER_1_ACCESS"`</ul></li> | `map(string)` | `null` | no |
| <a name="input_mount_targets"></a> [mount\_targets](#input\_mount\_targets) | Configuration block for EFS mount targets. Accepts a list of objects with the following settings:<br/><br/><ul><li>`subnet_id`: (Required) The ID of the subnet to add the mount target in</li><br/><li>`ip_address`: (Optional) The IPv4 address within the subnet's CIDR range where the mount target will be created</li><br/><li>`security_groups`: (Optional) A list of security group IDs (up to 5 items) to associate with the mount target</li><br/><li>`timeouts`: (Optional) Configuration block for operation timeouts<br/>  <ul><br/>    <li>`create`: (Optional) Time to wait for mount target(s) to be created. Must be a string specifying hours (h), minutes (m) or seconds (s)</li><br/>    <li>`delete`: (Optional) Time to wait for mount target(s) to be deleted. Must be a string specifying hours (h), minutes (m) or seconds (s)</li><br/>  </ul><br/></li></ul> | <pre>list(object({<br/>    subnet_id       = string<br/>    ip_address      = optional(string)<br/>    security_groups = optional(set(string))<br/><br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Elastic File System (EFS) | `string` | `null` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The file system performance mode. Can be either `"generalPurpose"` or `"maxIO"`. Defaults to `"generalPurpose"` | `string` | `"generalPurpose"` | no |
| <a name="input_policy_configuration"></a> [policy\_configuration](#input\_policy\_configuration) | Configuration block for EFS policy configuration. Supports the following settings:<br/><br/><ul><li>`version`: (Optional) The version of the IAM policy document. Valid values are `"2008-10-17"` or `"2012-10-17"`</ul></li><br/><br/><ul><li>`override_policy_documents`: (Optional) List of IAM policy documents that are merged together into the exported document. <br/>  Statements defined in `statements` block will be added to the document after merging `override_policy_documents`</ul></li><br/><br/><ul><li>`policy_id`: (Optional) ID for the policy. For example, `"MYFILESYSTEMPOLICY"`</ul></li><br/><br/><ul><li>`source_policy_documents`: (Optional) List of IAM policy documents that are merged together into the exported document.<br/>  Statements defined in `statements` block will be added to the document after merging `source_policy_documents`</ul></li><br/><br/><ul><br/>  <li>`statements`: (Optional) List of policy statement blocks. Each statement supports:<br/>    <ul><br/>      <li>`sid`: (Optional) Statement ID, unique identifier for the statement</li><br/>      <li>`effect`: (Optional) Whether statement allows or denies access. Valid values: `"Allow"` or `"Deny"`</li><br/>      <li>`actions`: (Optional) List of actions that the policy allows or denies</li><br/>      <li>`condition`: (Optional) Conditions for when the policy is in effect<br/>        <ul><br/>          <li>`test`: (Required) Condition operator. e.g. `"StringEquals"`</li><br/>          <li>`variable`: (Required) Context variable to apply condition to</li><br/>          <li>`values`: (Required) List of values to compare against</li><br/>        </ul><br/>      </li><br/>      <li>`not_actions`: (Optional) List of actions that the statement does not apply to</li><br/>      <li>`not_principals`: (Optional) List of principals that the statement does not apply to<br/>        <ul><br/>          <li>`identifiers`: (Required) List of principal identifiers</li><br/>          <li>`type`: (Required) Type of principal (e.g. `"AWS"`, `"Service"`)</li><br/>        </ul><br/>      </li><br/>      <li>`not_resources`: (Optional) List of resources that the statement does not apply to</li><br/>      <li>`principals`: (Optional) List of principals that the statement applies to<br/>        <ul><br/>          <li>`identifiers`: (Required) List of principal identifiers</li><br/>          <li>`type`: (Required) Type of principal (e.g. `"AWS"`, `"Service"`)</li><br/>        </ul><br/>      </li><br/>      <li>`resources`: (Optional) List of resources that the statement applies to</li><br/>    </ul><br/>  </li><br/></ul><br/><br/><ul><li>`bypass_policy_lockout_safety_check`: (Optional) A flag to indicate whether to bypass the "aws:PrincipalArn" condition key policy lockout safety check. <br/>  Setting this value to `true` increases the risk that the file system becomes locked</ul></li> | <pre>object({<br/>    version                   = optional(string)<br/>    override_policy_documents = optional(set(any))<br/>    policy_id                 = optional(string)<br/>    source_policy_documents   = optional(set(string))<br/><br/>    statements = optional(list(object({<br/>      sid     = optional(string)<br/>      effect  = optional(string)<br/>      actions = optional(set(string))<br/><br/>      condition = optional(object({<br/>        test     = string<br/>        variable = string<br/>        values   = set(string)<br/>      }))<br/><br/>      not_actions = optional(set(any))<br/><br/>      not_principals = optional(set(object({<br/>        identifiers = set(string)<br/>        type        = string<br/>      })))<br/><br/>      not_resources = optional(set(string))<br/><br/>      principals = optional(set(object({<br/>        identifiers = set(string)<br/>        type        = string<br/>      })))<br/><br/>      resources = optional(set(string))<br/>    })))<br/><br/>    bypass_policy_lockout_safety_check = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_protection"></a> [protection](#input\_protection) | Configuration block for EFS file system protection settings. Supports the following settings:<br/><br/><ul><li>`replication_overwrite`: (Optional) Indicates whether the destination file system can overwrite the source file system.<br/>  Valid values: <br/>  <ul><li>`"ENABLED"`: Allows the destination file system to overwrite the source file system</li><br/>  <li>`"DISABLED"`: Prevents the destination file system from overwriting the source file system</li></ul><br/></li></ul> | <pre>object({<br/>    replication_overwrite = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | The throughput, measured in MiB/s, to provision for the file system. Only applicable with `throughput_mode` set to `"provisioned"` | `number` | `null` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Configuration block for EFS replication configuration. Supports the following settings:<br/><br/><ul><li>`region`: (Optional) The AWS Region to replicate the file system to. Must be different from the source file system's region</ul></li><br/><br/><ul><li>`availability_zone_name`: (Optional) The availability zone in which the replica should be created. If specified, the replica will be <br/>  created with One Zone storage. If omitted, regional storage will be used</ul></li><br/><br/><ul><li>`file_system_id`: (Optional) The ID of an existing file system to use as the destination for replication. If not specified, <br/>  a new file system will be created with default settings</ul></li><br/><br/><ul><li>`kms_key_id`: (Optional) The ARN, ID alias, or alias ARN of the AWS KMS key used to encrypt the destination file system.<br/>  The default KMS key for EFS `"/aws/elasticfilesystem"` will be used</ul></li><br/><br/><ul><li>`timeouts`: (Optional) Configuration block for operation timeouts<br/>  <ul><br/>    <li>`create`: (Optional) Time to wait for replication to be created. Must be a string specifying hours (h), minutes (m) or seconds (s)</li><br/>    <li>`delete`: (Optional) Time to wait for replication to be deleted. Must be a string specifying hours (h), minutes (m) or seconds (s)</li><br/>  </ul><br/></li></ul> | <pre>object({<br/>    region                 = optional(string)<br/>    availability_zone_name = optional(string)<br/>    file_system_id         = optional(string)<br/>    kms_key_id             = optional(string)<br/><br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_security_group_configuration"></a> [security\_group\_configuration](#input\_security\_group\_configuration) | Configuration for AWS security group with flexible rule management:<br/><br/><ul><br/><li>`description`: (Optional) The description of the security group</li><br/><li>`name_prefix`: (Optional) The prefix for generating a unique security group name</li><br/><li>`name`: (Optional) The exact name for the security group</li><br/><li>`vpc_id`: (Optional) The VPC ID where the security group will be created</li><br/><li>`ingress_rules`: (Optional) The map of security group ingress rules with granular configuration<br/> <ul><br/>   <li>`description`: (Optional) The description for individual rule</li><br/>   <li>`cidr_blocks`: (Optional) The IPv4 CIDR ranges for rule</li><br/>   <li>`ipv6_cidr_blocks`: (Optional) The IPv6 CIDR ranges for rule</li><br/>   <li>`prefix_list_ids`: (Optional) The referenced prefix lists</li><br/>   <li>`self`: (Optional) Whether rule references the security group itself</li><br/>   <li>`source_security_group_id`: (Optional) The source security group for rule</li><br/> </ul><br/> </li><br/><li>`egress_rules`: (Optional) The map of security group egress rules with granular configuration<br/> <ul><br/>   <li>`description`: (Optional) The description for individual rule</li><br/>   <li>`protocol`: (Required) The protocol for rule (e.g. `"tcp"`)</li><br/>   <li>`from_port`: (Required) The start port for rule (e.g. `"80"`)</li><br/>   <li>`to_port`: (Required) The end port for rule (e.g. `"80"`)</li><br/>   <li>`cidr_blocks`: (Optional) The IPv4 CIDR ranges for rule</li><br/>   <li>`ipv6_cidr_blocks`: (Optional) The IPv6 CIDR ranges for rule</li><br/>   <li>`prefix_list_ids`: (Optional) The referenced prefix lists</li><br/>   <li>`self`: (Optional) Whether rule references the security group itself</li><br/>   <li>`source_security_group_id`: (Optional) The source security group for rule</li><br/> </ul><br/></li><br/></ul> | <pre>object({<br/>    description = optional(string)<br/>    name_prefix = optional(string)<br/>    name        = optional(string)<br/>    vpc_id      = optional(string)<br/><br/>    ingress_rules = optional(map(object({<br/>      description              = optional(string)<br/>      cidr_blocks              = optional(set(string))<br/>      ipv6_cidr_blocks         = optional(set(string))<br/>      prefix_list_ids          = optional(set(string))<br/>      self                     = optional(bool)<br/>      source_security_group_id = optional(string)<br/>    })))<br/><br/>    egress_rules = optional(map(object({<br/>      description              = optional(string)<br/>      protocol                 = string<br/>      from_port                = string<br/>      to_port                  = string<br/>      cidr_blocks              = optional(set(string))<br/>      ipv6_cidr_blocks         = optional(set(string))<br/>      prefix_list_ids          = optional(set(string))<br/>      self                     = optional(bool)<br/>      source_security_group_id = optional(string)<br/>    })))<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system. Valid values: `"bursting"`, `"provisioned"`, or `"elastic"`.<br/>When using `"provisioned"`, also set `provisioned_throughput_in_mibps`". Defaults to `"bursting"` | `string` | `"bursting"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_points_arns"></a> [access\_points\_arns](#output\_access\_points\_arns) | The ARN(s) of the access point(s) |
| <a name="output_access_points_file_system_arn"></a> [access\_points\_file\_system\_arn](#output\_access\_points\_file\_system\_arn) | The Amazon Resource Name (ARN) of the EFS file system associated with the access point(s) |
| <a name="output_access_points_file_system_ids"></a> [access\_points\_file\_system\_ids](#output\_access\_points\_file\_system\_ids) | The ID(s) of the access point(s) |
| <a name="output_backup_policy_id"></a> [backup\_policy\_id](#output\_backup\_policy\_id) | The ID of the backup policy |
| <a name="output_file_system_arn"></a> [file\_system\_arn](#output\_file\_system\_arn) | The Amazon Resource Name (ARN) of the file system |
| <a name="output_file_system_availability_zone_id"></a> [file\_system\_availability\_zone\_id](#output\_file\_system\_availability\_zone\_id) | The identifier of the Availability Zone in which the file system's One Zone storage classes exist |
| <a name="output_file_system_dns_name"></a> [file\_system\_dns\_name](#output\_file\_system\_dns\_name) | The DNS name for the filesystem per documented convention |
| <a name="output_file_system_id"></a> [file\_system\_id](#output\_file\_system\_id) | The ID that identifies the file system |
| <a name="output_file_system_name"></a> [file\_system\_name](#output\_file\_system\_name) | The value of the file system's `Name` tag |
| <a name="output_file_system_number_of_mount_targets"></a> [file\_system\_number\_of\_mount\_targets](#output\_file\_system\_number\_of\_mount\_targets) | The current number of mount targets that the file system has |
| <a name="output_file_system_owner_id"></a> [file\_system\_owner\_id](#output\_file\_system\_owner\_id) | The AWS account that created the file system. If the file system was createdby an IAM user, the parent account to which the user belongs is the owner |
| <a name="output_file_system_policy_id"></a> [file\_system\_policy\_id](#output\_file\_system\_policy\_id) | The ID that identifies the file system policy |
| <a name="output_file_system_size_in_bytes"></a> [file\_system\_size\_in\_bytes](#output\_file\_system\_size\_in\_bytes) | The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time |
| <a name="output_mount_targets_availability_zone_ids"></a> [mount\_targets\_availability\_zone\_ids](#output\_mount\_targets\_availability\_zone\_ids) | The unique and consistent identifier of the Availability Zone(s) that the mount target(s) reside in |
| <a name="output_mount_targets_availability_zone_names"></a> [mount\_targets\_availability\_zone\_names](#output\_mount\_targets\_availability\_zone\_names) | The name(s) of the Availability Zone(s) that the mount target(s) reside in |
| <a name="output_mount_targets_dns_names"></a> [mount\_targets\_dns\_names](#output\_mount\_targets\_dns\_names) | The DNS name(s) for the mount target(s) in each subnet/AZ, following the format `[az].[filesystem-id].efs.[region].amazonaws.com` |
| <a name="output_mount_targets_file_system_arn"></a> [mount\_targets\_file\_system\_arn](#output\_mount\_targets\_file\_system\_arn) | The Amazon Resource Name (ARN) of the EFS file system associated with the mount target(s). This will be the same ARN for all mount targets in a file system |
| <a name="output_mount_targets_file_system_dns_name"></a> [mount\_targets\_file\_system\_dns\_name](#output\_mount\_targets\_file\_system\_dns\_name) | The DNS name for the EFS file system, which can be used to mount the file system using the NFS protocol. This is the same for all mount targets in a file system |
| <a name="output_mount_targets_ids"></a> [mount\_targets\_ids](#output\_mount\_targets\_ids) | The ID(s) of the mount target(s) |
| <a name="output_mount_targets_network_interface_ids"></a> [mount\_targets\_network\_interface\_ids](#output\_mount\_targets\_network\_interface\_ids) | The ID(s) of the ENI(s) that AWS EFS automatically created and attached when provisioning the mount target(s). This ENI enables network connectivity to the EFS file system |
| <a name="output_mount_targets_owner_id"></a> [mount\_targets\_owner\_id](#output\_mount\_targets\_owner\_id) | The AWS account ID that owns the mount target(s) |
| <a name="output_replication_configuration_creation_time"></a> [replication\_configuration\_creation\_time](#output\_replication\_configuration\_creation\_time) | The timestamp indicating when the replication configuration was initially created (expressed in Unix timestamp format) |
| <a name="output_replication_configuration_destination_file_system_id"></a> [replication\_configuration\_destination\_file\_system\_id](#output\_replication\_configuration\_destination\_file\_system\_id) | The file system ID of the destination EFS replica created by the replication configuration |
| <a name="output_replication_configuration_destination_status"></a> [replication\_configuration\_destination\_status](#output\_replication\_configuration\_destination\_status) | The current status of the EFS replication configuration destination |
| <a name="output_replication_configuration_original_source_file_system_arn"></a> [replication\_configuration\_original\_source\_file\_system\_arn](#output\_replication\_configuration\_original\_source\_file\_system\_arn) | The Amazon Resource Name (ARN) of the original source Amazon EFS file system in the replication configuration |
| <a name="output_replication_configuration_source_file_system_arn"></a> [replication\_configuration\_source\_file\_system\_arn](#output\_replication\_configuration\_source\_file\_system\_arn) | The Amazon Resource Name (ARN) of the current source file system in the replication configuration |
| <a name="output_replication_configuration_source_file_system_region"></a> [replication\_configuration\_source\_file\_system\_region](#output\_replication\_configuration\_source\_file\_system\_region) | The AWS Region in which the source Amazon EFS file system is located |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource |
<!-- END_TF_DOCS -->