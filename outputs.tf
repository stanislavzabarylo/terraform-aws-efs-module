output "file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the file system"
  value       = try(aws_efs_file_system.this.arn, null)
}

output "file_system_availability_zone_id" {
  description = "The identifier of the Availability Zone in which the file system's One Zone storage classes exist"
  value       = try(aws_efs_file_system.this.availability_zone_id, null)
}

output "file_system_id" {
  description = "The ID that identifies the file system"
  value       = try(aws_efs_file_system.this.id, null)
}

output "file_system_dns_name" {
  description = "The DNS name for the filesystem per documented convention"
  value       = try(aws_efs_file_system.this.dns_name, null)
}

output "file_system_name" {
  description = "The value of the file system's `Name` tag"
  value       = try(aws_efs_file_system.this.name, null)
}

output "file_system_number_of_mount_targets" {
  description = "The current number of mount targets that the file system has"
  value       = try(aws_efs_file_system.this.number_of_mount_targets, null)
}

output "file_system_owner_id" {
  description = "The AWS account that created the file system. If the file system was createdby an IAM user, the parent account to which the user belongs is the owner"
  value       = try(aws_efs_file_system.this.owner_id, null)
}

output "file_system_size_in_bytes" {
  description = "The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time"
  value       = try(aws_efs_file_system.this.size_in_bytes, null)
}

output "access_points_arns" {
  description = "ARN(s) of the access point(s)"
  value       = try(values(aws_efs_access_point.this)[*].arn, null)
}

output "access_points_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the EFS file system associated with the access point(s)"
  value       = try(values(aws_efs_access_point.this)[0].file_system_arn, null)
}

output "access_points_file_system_ids" {
  description = "ID(s) of the access point(s)"
  value       = try(values(aws_efs_access_point.this)[*].id, null)
}

output "backup_policy_id" {
  description = "The ID of the backup policy"
  value       = try(aws_efs_backup_policy.this[0].id, null)
}

output "file_system_policy_id" {
  description = "The ID that identifies the file system policy"
  value       = try(aws_efs_file_system_policy.this[0].id, null)
}

output "mount_targets_ids" {
  description = "The ID(s) of the mount target(s)"
  value       = try(aws_efs_mount_target.this[*].id, null)
}

output "mount_targets_file_system_dns_name" {
  description = "The DNS name for the EFS file system, which can be used to mount the file system using the NFS protocol. This is the same for all mount targets in a file system"
  value       = try(aws_efs_mount_target.this[0].dns_name, null)
}

output "mount_targets_dns_names" {
  description = "The DNS name(s) for the mount target(s) in each subnet/AZ, following the format [az].[filesystem-id].efs.[region].amazonaws.com"
  value       = try(aws_efs_mount_target.this[*].mount_target_dns_name, null)
}

output "mount_targets_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the EFS file system associated with the mount target(s). This will be the same ARN for all mount targets in a file system"
  value       = try(aws_efs_mount_target.this[0].file_system_arn, null)
}

output "mount_targets_network_interface_ids" {
  description = "The ID(s) of the ENI(s) that AWS EFS automatically created and attached when provisioning the mount target(s). This ENI enables network connectivity to the EFS file system"
  value       = try(aws_efs_mount_target.this[*].network_interface_id, null)
}

output "mount_targets_availability_zone_names" {
  description = "The name(s) of the Availability Zone(s) that the mount target(s) reside in"
  value       = try(aws_efs_mount_target.this[*].availability_zone_name, null)
}

output "mount_targets_availability_zone_ids" {
  description = "The unique and consistent identifier of the Availability Zone(s) that the mount target(s) reside in"
  value       = try(aws_efs_mount_target.this[*].availability_zone_id, null)
}

output "mount_targets_owner_id" {
  description = "The AWS account ID that owns the mount target(s)"
  value       = try(aws_efs_mount_target.this[0].owner_id, null)
}

output "replication_configuration_creation_time" {
  description = "The timestamp indicating when the replication configuration was initially created (expressed in Unix timestamp format)"
  value       = try(aws_efs_replication_configuration.this[0].creation_time, null)
}

output "replication_configuration_destination_file_system_id" {
  description = "The file system ID of the destination EFS replica created by the replication configuration"
  value       = try(aws_efs_replication_configuration.this[0].destination[0].file_system_id, null)
}

output "replication_configuration_destination_status" {
  description = "The current status of the EFS replication configuration destination"
  value       = try(aws_efs_replication_configuration.this[0].destination[0].status, null)
}

output "replication_configuration_original_source_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the original source Amazon EFS file system in the replication configuration"
  value       = try(aws_efs_replication_configuration.this[0].original_source_file_system_arn, null)
}

output "replication_configuration_source_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the current source file system in the replication configuration"
  value       = try(aws_efs_replication_configuration.this[0].source_file_system_arn, null)
}

output "replication_configuration_source_file_system_region" {
  description = "The AWS Region in which the source Amazon EFS file system is located"
  value       = try(aws_efs_replication_configuration.this[0].source_file_system_region, null)
}

output "tags_all" {
  description = "A map of tags assigned to the resource"
  value       = try(aws_efs_file_system.this.tags_all, null)
}