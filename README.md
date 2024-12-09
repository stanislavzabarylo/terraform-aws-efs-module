# AWS Elastic File System Module

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
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.elastic_file_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | A map of access points to create for the file system. Each access point supports the following settings:<br/><br/><ul><li>`ac_name`</ul></li>: (Optional) A descriptive name for the access point.</ul></li><br/><br/><ul><br/>  <li>`posix_user`: (Optional) The operating system user and group applied to all file system requests made using the access point<br/>    <ul><br/>      <li>`gid`: (Required) The POSIX group ID used for all file system operations using this access point</li><br/>      <li>`secondary_gids`: (Optional) Secondary POSIX group IDs used for all file system operations using this access point</li><br/>      <li>`uid`: (Required) The POSIX user ID used for all file system operations using this access point</li><br/>    </ul><br/>  </li><br/></ul><br/><ul><br/>  <li>`root_directory`: (Optional) Configures the access point's root directory<br/>    <ul><br/>      <li>`path`: (Optional) The path on the EFS file system to expose as the root directory to NFS clients using the access point</li><br/>      <li>`creation_info`: (Optional) Specifies the POSIX IDs and permissions to apply to the access point's root directory<br/>        <ul><br/>          <li>`owner_gid`: (Required) The POSIX group ID to apply to the root directory</li><br/>          <li>`owner_uid`: (Required) The POSIX user ID to apply to the root directory</li><br/>          <li>`permissions`: (Required) The POSIX permissions to apply to the root directory, in numeric notation (e.g. `"0755"`)</li><br/>      </li><br/>    </ul><br/>  </li><br/></ul> | <pre>map(object({<br/>    ac_name = optional(string)<br/>    posix_user = optional(object({<br/>      gid            = number<br/>      secondary_gids = optional(set(number))<br/>      uid            = number<br/>    }))<br/>    root_directory = optional(object({<br/>      path = optional(string)<br/>      creation_info = optional(object({<br/>        owner_gid   = number<br/>        owner_uid   = number<br/>        permissions = string<br/>      }))<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_availability_zone_name"></a> [availability\_zone\_name](#input\_availability\_zone\_name) | The AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes | `string` | `null` | no |
| <a name="input_creation_token"></a> [creation\_token](#input\_creation\_token) | A unique name to your encryption key. Required if using KMS key | `string` | `null` | no |
| <a name="input_enable_automatic_backups"></a> [enable\_automatic\_backups](#input\_enable\_automatic\_backups) | If `true`, automatic backups will be enabled for the file system | `bool` | `false` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | If `true`, the disk will be encrypted | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN for the KMS encryption key. Required if encrypted is `true` | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | Configuration for EFS lifecycle policy transitions. Supports the following settings:<br/><br/><ul><li>`"transition_to_archive"`: (Optional) Indicates how long it takes to transition files to the Archive storage class. <br/>  Valid values: `"AFTER_1_DAY"`, `"AFTER_7_DAYS"`, `"AFTER_14_DAYS"`, `"AFTER_30_DAYS"`, `"AFTER_60_DAYS"`, `"AFTER_90_DAYS"`, <br/>  `"AFTER_180_DAYS"`, `"AFTER_270_DAYS"`, `"AFTER_365_DAYS"`. Requires `transition_to_ia` to be set.</ul></li><br/><br/><ul><li>`"transition_to_ia"`: (Optional) Indicates how long it takes to transition files to the IA storage class. <br/>  Valid values: `"AFTER_1_DAY"`, `"AFTER_7_DAYS"`, `"AFTER_14_DAYS"`, `"AFTER_30_DAYS"`, `"AFTER_60_DAYS"`, `"AFTER_90_DAYS"`, <br/>  `"AFTER_180_DAYS"`, `"AFTER_270_DAYS"`, `"AFTER_365_DAYS"`</ul></li><br/><br/><ul><li>`"transition_to_primary_storage_class"`: (Optional) Indicates how long it takes to transition files back to <br/>  the primary storage class. Only valid value is `"AFTER_1_ACCESS"`</ul></li> | `map(string)` | `null` | no |
| <a name="input_mount_targets"></a> [mount\_targets](#input\_mount\_targets) | Configuration block for EFS mount targets. Accepts a list of objects with the following settings:<br/><br/><ul><li>`subnet_id`: (Required) The ID of the subnet to add the mount target in</li><br/><li>`ip_address`: (Optional) The IPv4 address within the subnet's CIDR range where the mount target will be created</li><br/><li>`security_groups`: (Optional) A list of security group IDs to associate with the mount target</li></ul> | <pre>list(object({<br/>    subnet_id       = string<br/>    ip_address      = optional(string)<br/>    security_groups = optional(list(string))<br/>  }))</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Elastic File System (EFS) | `string` | `"elastic-file-system"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The file system performance mode. Can be either `"generalPurpose"` or `"maxIO"` | `string` | `"generalPurpose"` | no |
| <a name="input_policy_configuration"></a> [policy\_configuration](#input\_policy\_configuration) | Configuration block for EFS policy configuration. Supports the following settings:<br/><br/><ul><li>`version`: (Optional) The version of the IAM policy document. Valid values are `"2008-10-17"` or `"2012-10-17"`</ul></li><br/><br/><ul><li>`override_policy_documents`: (Optional) List of IAM policy documents that are merged together into the exported document. <br/>  Statements defined in `statements` block will be added to the document after merging `override_policy_documents`</ul></li><br/><br/><ul><li>`policy_id`: (Optional) ID for the policy. For example, `"MYFILESYSTEMPOLICY"`</ul></li><br/><br/><ul><li>`source_policy_documents`: (Optional) List of IAM policy documents that are merged together into the exported document.<br/>  Statements defined in `statements` block will be added to the document after merging `source_policy_documents`</ul></li><br/><br/><ul><br/>  <li>`statements`: (Optional) List of policy statement blocks. Each statement supports:<br/>    <ul><br/>      <li>`sid`: (Optional) Statement ID, unique identifier for the statement</li><br/>      <li>`effect`: (Optional) Whether statement allows or denies access. Valid values: `"Allow"` or `"Deny"`</li><br/>      <li>`actions`: (Optional) List of actions that the policy allows or denies</li><br/>      <li>`condition`: (Optional) Conditions for when the policy is in effect<br/>        <ul><br/>          <li>`test`: (Required) Condition operator. e.g. `"StringEquals"`</li><br/>          <li>`variable`: (Required) Context variable to apply condition to</li><br/>          <li>`values`: (Required) List of values to compare against</li><br/>        </ul><br/>      </li><br/>      <li>`not_actions`: (Optional) List of actions that the statement does not apply to</li><br/>      <li>`not_principals`: (Optional) List of principals that the statement does not apply to<br/>        <ul><br/>          <li>`identifiers`: (Required) List of principal identifiers</li><br/>          <li>`type`: (Required) Type of principal (e.g. `"AWS"`, `"Service"`)</li><br/>        </ul><br/>      </li><br/>      <li>`not_resources`: (Optional) List of resources that the statement does not apply to</li><br/>      <li>`principals`: (Optional) List of principals that the statement applies to<br/>        <ul><br/>          <li>`identifiers`: (Required) List of principal identifiers</li><br/>          <li>`type`: (Required) Type of principal (e.g. `"AWS"`, `"Service"`)</li><br/>        </ul><br/>      </li><br/>      <li>`resources`: (Optional) List of resources that the statement applies to</li><br/>    </ul><br/>  </li><br/></ul><br/><br/><ul><li>`bypass_policy_lockout_safety_check`: (Optional) A flag to indicate whether to bypass the "aws:PrincipalArn" condition key policy lockout safety check. <br/>  Setting this value to `true` increases the risk that the file system becomes locked</ul></li> | <pre>object({<br/>    version                   = optional(string)<br/>    override_policy_documents = optional(list(any))<br/>    policy_id                 = optional(string)<br/>    source_policy_documents   = optional(list(string))<br/><br/>    statements = optional(list(object({<br/>      sid     = optional(string)<br/>      effect  = optional(string)<br/>      actions = optional(list(string))<br/><br/>      condition = optional(object({<br/>        test     = string<br/>        variable = string<br/>        values   = list(string)<br/>      }))<br/><br/>      not_actions = optional(list(any))<br/><br/>      not_principals = optional(list(object({<br/>        identifiers = list(string)<br/>        type        = string<br/>      })))<br/><br/>      not_resources = optional(list(string))<br/><br/>      principals = optional(list(object({<br/>        identifiers = list(string)<br/>        type        = string<br/>      })))<br/><br/>      resources = optional(list(string))<br/>    })))<br/><br/>    bypass_policy_lockout_safety_check = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_protection"></a> [protection](#input\_protection) | Configuration block for EFS file system protection settings. Supports the following settings:<br/><br/><ul><li>`replication_overwrite`: (Optional) Indicates whether the destination file system can overwrite the source file system.<br/>  Valid values: <br/>  <ul><li>`"ENABLED"`: Allows the destination file system to overwrite the source file system</li><br/>  <li>`"DISABLED"`: Prevents the destination file system from overwriting the source file system</li></ul><br/></li></ul> | <pre>object({<br/>    replication_overwrite = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | The throughput, measured in MiB/s, to provision for the file system. Only applicable with `throughput_mode` set to `"provisioned"` | `number` | `null` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Configuration block for EFS replication configuration. Supports the following settings:<br/><br/><ul><li>`region`: (Optional) The AWS Region to replicate the file system to. Must be different from the source file system's region</ul></li><br/><br/><ul><li>`availability_zone_name`: (Optional) The availability zone in which the replica should be created. If specified, the replica will be <br/>  created with One Zone storage. If omitted, regional storage will be used</ul></li><br/><br/><ul><li>`file_system_id`: (Optional) The ID of an existing file system to use as the destination for replication. If not specified, <br/>  a new file system will be created with default settings</ul></li><br/><br/><ul><li>`kms_key_id`: (Optional) The ARN, ID alias, or alias ARN of the AWS KMS key used to encrypt the destination file system. t<br/>  The default KMS key for EFS `"/aws/elasticfilesystem"` will be used</ul></li> | <pre>object({<br/>    region                 = optional(string)<br/>    availability_zone_name = optional(string)<br/>    file_system_id         = optional(string)<br/>    kms_key_id             = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system. Valid values: `"bursting"`, `"provisioned"`, or `"elastic"`. When using `"provisioned"`, also set `provisioned_throughput_in_mibps` | `string` | `"bursting"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_points_arns"></a> [access\_points\_arns](#output\_access\_points\_arns) | ARN(s) of the access point(s) |
| <a name="output_access_points_file_system_arn"></a> [access\_points\_file\_system\_arn](#output\_access\_points\_file\_system\_arn) | The Amazon Resource Name (ARN) of the EFS file system associated with the access point(s) |
| <a name="output_access_points_file_system_ids"></a> [access\_points\_file\_system\_ids](#output\_access\_points\_file\_system\_ids) | ID(s) of the access point(s) |
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
| <a name="output_mount_targets_dns_names"></a> [mount\_targets\_dns\_names](#output\_mount\_targets\_dns\_names) | The DNS name(s) for the mount target(s) in each subnet/AZ, following the format [az].[filesystem-id].efs.[region].amazonaws.com |
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
