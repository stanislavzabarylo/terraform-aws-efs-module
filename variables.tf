variable "name" {
  type        = string
  description = "A unique name for the Elastic File System (EFS)"
  default     = null
}

variable "availability_zone_name" {
  type        = string
  description = "The AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes"
  default     = null
}

variable "creation_token" {
  type        = string
  description = <<-EOT
A unique name used to ensure idempotent file system creation. 
If not specified, defaults to an auto-generated string combining timestamp and UUID in the format: 
`"terraform-<YYYYMMDDhhmmss>-<random_uuid>"` (defined as a local value in `main.tf` file)
EOT
  default     = null
}

variable "encrypted" {
  type        = bool
  description = "If `true`, the disk will be encrypted. Defaults to `true`"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying `kms_key_id`, `encrypted` needs to be set to `true`"
  default     = null
}

variable "lifecycle_policy" {
  type        = map(string)
  description = <<-EOT
Configuration for EFS lifecycle policy transitions. Supports the following settings:

<ul><li>`"transition_to_archive"`: (Optional) Indicates how long it takes to transition files to the Archive storage class. 
  Requires `"transition_to_ia"` to be specified, with `"performance_mode"` set to `"generalPurpose"` and `"throughput_mode"` set to `"elastic"`.
  Valid values: `"AFTER_1_DAY"`, `"AFTER_7_DAYS"`, `"AFTER_14_DAYS"`, `"AFTER_30_DAYS"`, `"AFTER_60_DAYS"`, `"AFTER_90_DAYS"`, 
  `"AFTER_180_DAYS"`, `"AFTER_270_DAYS"`, `"AFTER_365_DAYS"`</ul></li>

<ul><li>`"transition_to_ia"`: (Optional) Indicates how long it takes to transition files to the IA storage class. 
  Valid values: `"AFTER_1_DAY"`, `"AFTER_7_DAYS"`, `"AFTER_14_DAYS"`, `"AFTER_30_DAYS"`, `"AFTER_60_DAYS"`, `"AFTER_90_DAYS"`, 
  `"AFTER_180_DAYS"`, `"AFTER_270_DAYS"`, `"AFTER_365_DAYS"`</ul></li>

<ul><li>`"transition_to_primary_storage_class"`: (Optional) Indicates how long it takes to transition files back to 
  the primary storage class. Only valid value is `"AFTER_1_ACCESS"`</ul></li>
EOT
  default     = null
}

variable "protection" {
  type = object({
    replication_overwrite = optional(string)
  })
  description = <<-EOT
Configuration block for EFS file system protection settings. Supports the following settings:

<ul><li>`replication_overwrite`: (Optional) Indicates whether the destination file system can overwrite the source file system.
  Valid values: 
  <ul><li>`"ENABLED"`: Allows the destination file system to overwrite the source file system</li>
  <li>`"DISABLED"`: Prevents the destination file system from overwriting the source file system</li></ul>
</li></ul>
EOT
  default     = null
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `\"generalPurpose\"` or `\"maxIO\"`. Defaults to `\"generalPurpose\"`"
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  type        = number
  description = "The throughput, measured in MiB/s, to provision for the file system. Only applicable with `throughput_mode` set to `\"provisioned\"`"
  default     = null
}

variable "throughput_mode" {
  type        = string
  description = <<-EOT
Throughput mode for the file system. Valid values: `"bursting"`, `"provisioned"`, or `"elastic"`.
When using `"provisioned"`, also set `provisioned_throughput_in_mibps`". Defaults to `"bursting"`
EOT
  default     = "bursting"
}

variable "enable_automatic_backups" {
  type        = bool
  description = "If `true`, automatic backups will be enabled for the file system. Defaults to `false`"
  default     = false
}

variable "replication_configuration" {
  type = object({
    region                 = optional(string)
    availability_zone_name = optional(string)
    file_system_id         = optional(string)
    kms_key_id             = optional(string)

    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
    }))
  })
  description = <<-EOT
Configuration block for EFS replication configuration. Supports the following settings:

<ul><li>`region`: (Optional) The AWS Region to replicate the file system to. Must be different from the source file system's region</ul></li>

<ul><li>`availability_zone_name`: (Optional) The availability zone in which the replica should be created. If specified, the replica will be 
  created with One Zone storage. If omitted, regional storage will be used</ul></li>

<ul><li>`file_system_id`: (Optional) The ID of an existing file system to use as the destination for replication. If not specified, 
  a new file system will be created with default settings</ul></li>

<ul><li>`kms_key_id`: (Optional) The ARN, ID alias, or alias ARN of the AWS KMS key used to encrypt the destination file system.
  The default KMS key for EFS `"/aws/elasticfilesystem"` will be used</ul></li>

<ul><li>`timeouts`: (Optional) Configuration block for operation timeouts
  <ul>
    <li>`create`: (Optional) Time to wait for replication to be created. Must be a string specifying hours (h), minutes (m) or seconds (s)</li>
    <li>`delete`: (Optional) Time to wait for replication to be deleted. Must be a string specifying hours (h), minutes (m) or seconds (s)</li>
  </ul>
</li></ul>
EOT
  default     = null
}

variable "access_points" {
  type = map(object({
    name = optional(string)
    posix_user = optional(object({
      gid            = number
      secondary_gids = optional(set(number))
      uid            = number
    }))
    root_directory = optional(object({
      path = optional(string)
      creation_info = optional(object({
        owner_gid   = number
        owner_uid   = number
        permissions = string
      }))
    }))
  }))
  description = <<-EOT
A map of access points to create for the file system. Each access point supports the following settings:

<ul><li>`name`</ul></li>: (Optional) A descriptive name for the access point.</ul></li>

<ul>
  <li>`posix_user`: (Optional) The operating system user and group applied to all file system requests made using the access point
    <ul>
      <li>`gid`: (Required) The POSIX group ID used for all file system operations using this access point</li>
      <li>`secondary_gids`: (Optional) Secondary POSIX group IDs used for all file system operations using this access point</li>
      <li>`uid`: (Required) The POSIX user ID used for all file system operations using this access point</li>
    </ul>
  </li>
</ul>
<ul>
  <li>`root_directory`: (Optional) Configures the access point's root directory
    <ul>
      <li>`path`: (Optional) The path on the EFS file system to expose as the root directory to NFS clients using the access point</li>
      <li>`creation_info`: (Optional) Specifies the POSIX IDs and permissions to apply to the access point's root directory
        <ul>
          <li>`owner_gid`: (Required) The POSIX group ID to apply to the root directory</li>
          <li>`owner_uid`: (Required) The POSIX user ID to apply to the root directory</li>
          <li>`permissions`: (Required) The POSIX permissions to apply to the root directory, in numeric notation (e.g. `"0755"`)</li>
      </li>
    </ul>
  </li>
</ul>
EOT
  default     = null

  validation {
    condition = (
      var.access_points == null ? true : (
        alltrue([
          for ap in var.access_points :
          ap.posix_user == null ? true : (
            ap.posix_user.uid >= 0 && ap.posix_user.uid <= 4294967295
          )
        ])
      )
    )
    error_message = "POSIX user ID (uid) must be between 0 and 4294967295"
  }

  validation {
    condition = (
      var.access_points == null ? true : (
        alltrue([
          for ap in var.access_points :
          ap.posix_user == null ? true : (
            ap.posix_user.gid >= 0 && ap.posix_user.gid <= 4294967295
          )
        ])
      )
    )
    error_message = "POSIX group ID (gid) must be between 0 and 4294967295"
  }

  validation {
    condition = (
      var.access_points == null ? true : (
        alltrue([
          for ap in var.access_points :
          ap.posix_user == null ? true : (
            ap.posix_user.secondary_gids == null ? true : (
              alltrue([
                for gid in ap.posix_user.secondary_gids :
                gid >= 0 && gid <= 4294967295
              ])
            )
          )
        ])
      )
    )
    error_message = "Secondary POSIX group IDs must be between 0 and 4294967295"
  }

  validation {
    condition = (
      var.access_points == null ? true : (
        alltrue([
          for ap in var.access_points :
          ap.root_directory == null ? true : (
            ap.root_directory.creation_info == null ? true : (
              ap.root_directory.creation_info.owner_uid >= 0 && ap.root_directory.creation_info.owner_uid <= 4294967295
            )
          )
        ])
      )
    )
    error_message = "Root directory owner UID must be between 0 and 4294967295"
  }

  validation {
    condition = (
      var.access_points == null ? true : (
        alltrue([
          for ap in var.access_points :
          ap.root_directory == null ? true : (
            ap.root_directory.creation_info == null ? true : (
              ap.root_directory.creation_info.owner_gid >= 0 && ap.root_directory.creation_info.owner_gid <= 4294967295
            )
          )
        ])
      )
    )
    error_message = "Root directory owner GID must be between 0 and 4294967295"
  }

  validation {
    condition = (
      var.access_points == null ? true : (
        alltrue([
          for ap in var.access_points :
          ap.root_directory == null ? true : (
            ap.root_directory.creation_info == null ? true : (
              can(regex("^[0-7]?[0-7]{3}$", ap.root_directory.creation_info.permissions))
            )
          )
        ])
      )
    )
    error_message = "Root directory permissions must be a valid 3 or 4-digit octal string (e.g., \"755\" or \"0755\")."
  }
}

variable "mount_targets" {
  type = list(object({
    subnet_id       = string
    ip_address      = optional(string)
    security_groups = optional(set(string))

    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
    }))
  }))
  description = <<-EOT
Configuration block for EFS mount targets. Accepts a list of objects with the following settings:

<ul><li>`subnet_id`: (Required) The ID of the subnet to add the mount target in</li>
<li>`ip_address`: (Optional) The IPv4 address within the subnet's CIDR range where the mount target will be created</li>
<li>`security_groups`: (Optional) A list of security group IDs (up to 5 items) to associate with the mount target</li>
<li>`timeouts`: (Optional) Configuration block for operation timeouts
  <ul>
    <li>`create`: (Optional) Time to wait for mount target(s) to be created. Must be a string specifying hours (h), minutes (m) or seconds (s)</li>
    <li>`delete`: (Optional) Time to wait for mount target(s) to be deleted. Must be a string specifying hours (h), minutes (m) or seconds (s)</li>
  </ul>
</li></ul>
EOT
  default     = null
}

variable "policy_configuration" {
  type = object({
    version                   = optional(string)
    override_policy_documents = optional(set(any))
    policy_id                 = optional(string)
    source_policy_documents   = optional(set(string))

    statements = optional(list(object({
      sid     = optional(string)
      effect  = optional(string)
      actions = optional(set(string))

      condition = optional(object({
        test     = string
        variable = string
        values   = set(string)
      }))

      not_actions = optional(set(any))

      not_principals = optional(set(object({
        identifiers = set(string)
        type        = string
      })))

      not_resources = optional(set(string))

      principals = optional(set(object({
        identifiers = set(string)
        type        = string
      })))

      resources = optional(set(string))
    })))

    bypass_policy_lockout_safety_check = optional(bool)
  })
  description = <<-EOT
Configuration block for EFS policy configuration. Supports the following settings:

<ul><li>`version`: (Optional) The version of the IAM policy document. Valid values are `"2008-10-17"` or `"2012-10-17"`</ul></li>

<ul><li>`override_policy_documents`: (Optional) List of IAM policy documents that are merged together into the exported document. 
  Statements defined in `statements` block will be added to the document after merging `override_policy_documents`</ul></li>

<ul><li>`policy_id`: (Optional) ID for the policy. For example, `"MYFILESYSTEMPOLICY"`</ul></li>

<ul><li>`source_policy_documents`: (Optional) List of IAM policy documents that are merged together into the exported document.
  Statements defined in `statements` block will be added to the document after merging `source_policy_documents`</ul></li>

<ul>
  <li>`statements`: (Optional) List of policy statement blocks. Each statement supports:
    <ul>
      <li>`sid`: (Optional) Statement ID, unique identifier for the statement</li>
      <li>`effect`: (Optional) Whether statement allows or denies access. Valid values: `"Allow"` or `"Deny"`</li>
      <li>`actions`: (Optional) List of actions that the policy allows or denies</li>
      <li>`condition`: (Optional) Conditions for when the policy is in effect
        <ul>
          <li>`test`: (Required) Condition operator. e.g. `"StringEquals"`</li>
          <li>`variable`: (Required) Context variable to apply condition to</li>
          <li>`values`: (Required) List of values to compare against</li>
        </ul>
      </li>
      <li>`not_actions`: (Optional) List of actions that the statement does not apply to</li>
      <li>`not_principals`: (Optional) List of principals that the statement does not apply to
        <ul>
          <li>`identifiers`: (Required) List of principal identifiers</li>
          <li>`type`: (Required) Type of principal (e.g. `"AWS"`, `"Service"`)</li>
        </ul>
      </li>
      <li>`not_resources`: (Optional) List of resources that the statement does not apply to</li>
      <li>`principals`: (Optional) List of principals that the statement applies to
        <ul>
          <li>`identifiers`: (Required) List of principal identifiers</li>
          <li>`type`: (Required) Type of principal (e.g. `"AWS"`, `"Service"`)</li>
        </ul>
      </li>
      <li>`resources`: (Optional) List of resources that the statement applies to</li>
    </ul>
  </li>
</ul>

<ul><li>`bypass_policy_lockout_safety_check`: (Optional) A flag to indicate whether to bypass the "aws:PrincipalArn" condition key policy lockout safety check. 
  Setting this value to `true` increases the risk that the file system becomes locked</ul></li>
EOT
  default     = null
}

variable "security_group_configuration" {
  type = object({
    description = optional(string)
    name_prefix = optional(string)
    name        = optional(string)
    vpc_id      = optional(string)

    ingress_rules = optional(map(object({
      description              = optional(string)
      cidr_blocks              = optional(set(string))
      ipv6_cidr_blocks         = optional(set(string))
      prefix_list_ids          = optional(set(string))
      self                     = optional(bool)
      source_security_group_id = optional(string)
    })))

    egress_rules = optional(map(object({
      description              = optional(string)
      protocol                 = string
      from_port                = string
      to_port                  = string
      cidr_blocks              = optional(set(string))
      ipv6_cidr_blocks         = optional(set(string))
      prefix_list_ids          = optional(set(string))
      self                     = optional(bool)
      source_security_group_id = optional(string)
    })))
  })
  description = <<-EOT
Configuration for AWS security group with flexible rule management:

<ul>
<li>`description`: (Optional) The description of the security group</li>
<li>`name_prefix`: (Optional) The prefix for generating a unique security group name</li>
<li>`name`: (Optional) The exact name for the security group</li>
<li>`vpc_id`: (Optional) The VPC ID where the security group will be created</li>
<li>`ingress_rules`: (Optional) The map of security group ingress rules with granular configuration
 <ul>
   <li>`description`: (Optional) The description for individual rule</li>
   <li>`cidr_blocks`: (Optional) The IPv4 CIDR ranges for rule</li>
   <li>`ipv6_cidr_blocks`: (Optional) The IPv6 CIDR ranges for rule</li>
   <li>`prefix_list_ids`: (Optional) The referenced prefix lists</li>
   <li>`self`: (Optional) Whether rule references the security group itself</li>
   <li>`source_security_group_id`: (Optional) The source security group for rule</li>
 </ul>
 </li>
<li>`egress_rules`: (Optional) The map of security group egress rules with granular configuration
 <ul>
   <li>`description`: (Optional) The description for individual rule</li>
   <li>`protocol`: (Required) The protocol for rule (e.g. `"tcp"`)</li>
   <li>`from_port`: (Required) The start port for rule (e.g. `"80"`)</li>
   <li>`to_port`: (Required) The end port for rule (e.g. `"80"`)</li>
   <li>`cidr_blocks`: (Optional) The IPv4 CIDR ranges for rule</li>
   <li>`ipv6_cidr_blocks`: (Optional) The IPv6 CIDR ranges for rule</li>
   <li>`prefix_list_ids`: (Optional) The referenced prefix lists</li>
   <li>`self`: (Optional) Whether rule references the security group itself</li>
   <li>`source_security_group_id`: (Optional) The source security group for rule</li>
 </ul>
</li>
</ul>
EOT
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}