<!-- BEGIN_TF_DOCS -->
# Complete AWS Elastic File System Module Example

This is a complete AWS Elastic File System example with all features enabled, including encryption, backup policies, lifecycle management, replication configuration, access points, and mount targets, to demonstrate the full range of the module's capabilitiesThis is a complete AWS Elastic File System example with all features enabled, including encryption, backup policies, lifecycle management, replication configuration, access points, and mount targets, to demonstrate the full range of the module's capabilities

## Usage

To use this complete example, execute the following commands:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs_complete"></a> [efs\_complete](#module\_efs\_complete) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_role.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_access_points_arns"></a> [efs\_access\_points\_arns](#output\_efs\_access\_points\_arns) | ARN(s) of the access point(s) |
| <a name="output_efs_access_points_file_system_arn"></a> [efs\_access\_points\_file\_system\_arn](#output\_efs\_access\_points\_file\_system\_arn) | The Amazon Resource Name (ARN) of the EFS file system associated with the access point(s) |
| <a name="output_efs_access_points_file_system_ids"></a> [efs\_access\_points\_file\_system\_ids](#output\_efs\_access\_points\_file\_system\_ids) | ID(s) of the access point(s) |
| <a name="output_efs_backup_policy_id"></a> [efs\_backup\_policy\_id](#output\_efs\_backup\_policy\_id) | The ID of the backup policy |
| <a name="output_efs_file_system_arn"></a> [efs\_file\_system\_arn](#output\_efs\_file\_system\_arn) | The Amazon Resource Name (ARN) of the file system |
| <a name="output_efs_file_system_availability_zone_id"></a> [efs\_file\_system\_availability\_zone\_id](#output\_efs\_file\_system\_availability\_zone\_id) | The identifier of the Availability Zone in which the file system's One Zone storage classes exist |
| <a name="output_efs_file_system_dns_name"></a> [efs\_file\_system\_dns\_name](#output\_efs\_file\_system\_dns\_name) | The DNS name for the filesystem per documented convention |
| <a name="output_efs_file_system_id"></a> [efs\_file\_system\_id](#output\_efs\_file\_system\_id) | The ID that identifies the file system |
| <a name="output_efs_file_system_name"></a> [efs\_file\_system\_name](#output\_efs\_file\_system\_name) | The value of the file system's `Name` tag |
| <a name="output_efs_file_system_number_of_mount_targets"></a> [efs\_file\_system\_number\_of\_mount\_targets](#output\_efs\_file\_system\_number\_of\_mount\_targets) | The current number of mount targets that the file system has |
| <a name="output_efs_file_system_owner_id"></a> [efs\_file\_system\_owner\_id](#output\_efs\_file\_system\_owner\_id) | The AWS account that created the file system. If the file system was createdby an IAM user, the parent account to which the user belongs is the owner |
| <a name="output_efs_file_system_policy_id"></a> [efs\_file\_system\_policy\_id](#output\_efs\_file\_system\_policy\_id) | The ID that identifies the file system |
| <a name="output_efs_file_system_size_in_bytes"></a> [efs\_file\_system\_size\_in\_bytes](#output\_efs\_file\_system\_size\_in\_bytes) | The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time |
| <a name="output_efs_mount_targets_availability_zone_ids"></a> [efs\_mount\_targets\_availability\_zone\_ids](#output\_efs\_mount\_targets\_availability\_zone\_ids) | The unique and consistent identifier of the Availability Zone (AZ) that the mount target resides in |
| <a name="output_efs_mount_targets_availability_zone_names"></a> [efs\_mount\_targets\_availability\_zone\_names](#output\_efs\_mount\_targets\_availability\_zone\_names) | The name of the Availability Zone (AZ) that the mount target resides in |
| <a name="output_efs_mount_targets_dns_names"></a> [efs\_mount\_targets\_dns\_names](#output\_efs\_mount\_targets\_dns\_names) | The DNS name for the given subnet/AZ per documented convention |
| <a name="output_efs_mount_targets_file_system_arn"></a> [efs\_mount\_targets\_file\_system\_arn](#output\_efs\_mount\_targets\_file\_system\_arn) | Amazon Resource Name of the file system |
| <a name="output_efs_mount_targets_file_system_dns_name"></a> [efs\_mount\_targets\_file\_system\_dns\_name](#output\_efs\_mount\_targets\_file\_system\_dns\_name) | The DNS name for the EFS file system |
| <a name="output_efs_mount_targets_ids"></a> [efs\_mount\_targets\_ids](#output\_efs\_mount\_targets\_ids) | The ID of the mount target |
| <a name="output_efs_mount_targets_network_interface_ids"></a> [efs\_mount\_targets\_network\_interface\_ids](#output\_efs\_mount\_targets\_network\_interface\_ids) | The ID of the network interface that Amazon EFS created when it created the mount target |
| <a name="output_efs_mount_targets_owner_id"></a> [efs\_mount\_targets\_owner\_id](#output\_efs\_mount\_targets\_owner\_id) | AWS account ID that owns the resource |
| <a name="output_efs_replication_configuration_creation_time"></a> [efs\_replication\_configuration\_creation\_time](#output\_efs\_replication\_configuration\_creation\_time) | When the replication configuration was created |
| <a name="output_efs_replication_configuration_destination_file_system_id"></a> [efs\_replication\_configuration\_destination\_file\_system\_id](#output\_efs\_replication\_configuration\_destination\_file\_system\_id) | The fs ID of the replica |
| <a name="output_efs_replication_configuration_destination_status"></a> [efs\_replication\_configuration\_destination\_status](#output\_efs\_replication\_configuration\_destination\_status) | The status of the replication |
| <a name="output_efs_replication_configuration_original_source_file_system_arn"></a> [efs\_replication\_configuration\_original\_source\_file\_system\_arn](#output\_efs\_replication\_configuration\_original\_source\_file\_system\_arn) | The Amazon Resource Name (ARN) of the original source Amazon EFS file system in the replication configuration |
| <a name="output_efs_replication_configuration_source_file_system_arn"></a> [efs\_replication\_configuration\_source\_file\_system\_arn](#output\_efs\_replication\_configuration\_source\_file\_system\_arn) | The Amazon Resource Name (ARN) of the current source file system in the replication configuration |
| <a name="output_efs_replication_configuration_source_file_system_region"></a> [efs\_replication\_configuration\_source\_file\_system\_region](#output\_efs\_replication\_configuration\_source\_file\_system\_region) | The AWS Region in which the source Amazon EFS file system is located |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource |
<!-- END_TF_DOCS -->