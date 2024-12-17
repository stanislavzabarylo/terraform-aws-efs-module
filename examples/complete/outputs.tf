output "efs_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the file system"
  value       = module.efs_complete.file_system_arn
}

output "efs_file_system_availability_zone_id" {
  description = "The identifier of the Availability Zone in which the file system's One Zone storage classes exist"
  value       = module.efs_complete.file_system_availability_zone_id
}

output "efs_file_system_id" {
  description = "The ID that identifies the file system"
  value       = module.efs_complete.file_system_id
}

output "efs_file_system_dns_name" {
  description = "The DNS name for the filesystem per documented convention"
  value       = module.efs_complete.file_system_dns_name
}

output "efs_file_system_name" {
  description = "The value of the file system's `Name` tag"
  value       = module.efs_complete.file_system_name
}

output "efs_file_system_number_of_mount_targets" {
  description = "The current number of mount targets that the file system has"
  value       = module.efs_complete.file_system_number_of_mount_targets
}

output "efs_file_system_owner_id" {
  description = "The AWS account that created the file system. If the file system was createdby an IAM user, the parent account to which the user belongs is the owner"
  value       = module.efs_complete.file_system_owner_id
}

output "efs_file_system_size_in_bytes" {
  description = "The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time"
  value       = module.efs_complete.file_system_size_in_bytes
}

output "efs_access_points_arns" {
  description = "ARN(s) of the access point(s)"
  value       = module.efs_complete.access_points_arns
}

output "efs_access_points_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the EFS file system associated with the access point(s)"
  value       = module.efs_complete.access_points_file_system_arn
}

output "efs_access_points_file_system_ids" {
  description = "ID(s) of the access point(s)"
  value       = module.efs_complete.access_points_file_system_ids
}

output "efs_backup_policy_id" {
  description = "The ID of the backup policy"
  value       = module.efs_complete.backup_policy_id
}

output "efs_file_system_policy_id" {
  description = "The ID that identifies the file system"
  value       = module.efs_complete.file_system_policy_id
}

output "efs_mount_targets_ids" {
  description = "The ID of the mount target"
  value       = module.efs_complete.mount_targets_ids
}

output "efs_mount_targets_file_system_dns_name" {
  description = "The DNS name for the EFS file system"
  value       = module.efs_complete.mount_targets_file_system_dns_name
}

output "efs_mount_targets_dns_names" {
  description = "The DNS name for the given subnet/AZ per documented convention"
  value       = module.efs_complete.mount_targets_dns_names
}

output "efs_mount_targets_file_system_arn" {
  description = "Amazon Resource Name of the file system"
  value       = module.efs_complete.mount_targets_file_system_arn
}

output "efs_mount_targets_network_interface_ids" {
  description = "The ID of the network interface that Amazon EFS created when it created the mount target"
  value       = module.efs_complete.mount_targets_network_interface_ids
}

output "efs_mount_targets_availability_zone_names" {
  description = "The name of the Availability Zone (AZ) that the mount target resides in"
  value       = module.efs_complete.mount_targets_availability_zone_names
}

output "efs_mount_targets_availability_zone_ids" {
  description = "The unique and consistent identifier of the Availability Zone (AZ) that the mount target resides in"
  value       = module.efs_complete.mount_targets_availability_zone_ids
}

output "efs_mount_targets_owner_id" {
  description = "AWS account ID that owns the resource"
  value       = module.efs_complete.mount_targets_owner_id
}

output "efs_replication_configuration_creation_time" {
  description = "When the replication configuration was created"
  value       = module.efs_complete.replication_configuration_creation_time
}

output "efs_replication_configuration_destination_file_system_id" {
  description = "The fs ID of the replica"
  value       = module.efs_complete.replication_configuration_creation_time
}

output "efs_replication_configuration_destination_status" {
  description = "The status of the replication"
  value       = module.efs_complete.replication_configuration_destination_status
}

output "efs_replication_configuration_original_source_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the original source Amazon EFS file system in the replication configuration"
  value       = module.efs_complete.replication_configuration_original_source_file_system_arn
}

output "efs_replication_configuration_source_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the current source file system in the replication configuration"
  value       = module.efs_complete.replication_configuration_source_file_system_arn
}

output "efs_replication_configuration_source_file_system_region" {
  description = "The AWS Region in which the source Amazon EFS file system is located"
  value       = module.efs_complete.replication_configuration_source_file_system_region
}

output "tags_all" {
  description = "A map of tags assigned to the resource"
  value       = module.efs_complete.tags_all
}