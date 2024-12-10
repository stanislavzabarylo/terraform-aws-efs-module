variable "name" {
  description = "A unique name for the Elastic File System (EFS)"
  type        = string
  default     = "elastic-file-system"
}

variable "availability_zone_name" {
  description = "The AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes"
  type        = string
  default     = null
}

variable "creation_token" {
  description = <<-EOT
A unique name used to ensure idempotent file system creation. 
If not specified, defaults to an auto-generated string combining timestamp and UUID in the format: 
`"terraform-<YYYYMMDDhhmmss>-<random_uuid>"` (defined as a local value in `main.tf` file)
EOT
  type        = string
  default     = null
}

variable "encrypted" {
  description = "If `true`, the disk will be encrypted. Defaults to `false`"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ARN for the KMS encryption key. Required if encrypted is `true`"
  type        = string
  default     = null
}

variable "lifecycle_policy" {
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
  type        = map(string)
  default     = null

  validation {
    condition = var.lifecycle_policy == null ? true : (
      lookup(var.lifecycle_policy, "transition_to_archive", null) == null ? true : contains([
        "AFTER_1_DAY", "AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS",
        "AFTER_180_DAYS", "AFTER_270_DAYS", "AFTER_365_DAYS"
      ], lookup(var.lifecycle_policy, "transition_to_archive"))
    )
    error_message = "transition_to_archive must be one of: \"AFTER_1_DAY\", \"AFTER_7_DAYS\", \"AFTER_14_DAYS\", \"AFTER_30_DAYS\", \"AFTER_60_DAYS\", \"AFTER_90_DAYS\", \"AFTER_180_DAYS\", \"AFTER_270_DAYS\", \"AFTER_365_DAYS\""
  }

  validation {
    condition = var.lifecycle_policy == null ? true : (
      lookup(var.lifecycle_policy, "transition_to_ia", null) == null ? true : contains([
        "AFTER_1_DAY", "AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS",
        "AFTER_180_DAYS", "AFTER_270_DAYS", "AFTER_365_DAYS"
      ], lookup(var.lifecycle_policy, "transition_to_ia"))
    )
    error_message = "transition_to_ia must be one of: \"AFTER_1_DAY\", \"AFTER_7_DAYS\", \"AFTER_14_DAYS\", \"AFTER_30_DAYS\", \"AFTER_60_DAYS\", \"AFTER_90_DAYS\", \"AFTER_180_DAYS\", \"AFTER_270_DAYS\", \"AFTER_365_DAYS\""
  }

  validation {
    condition = var.lifecycle_policy == null ? true : (
      lookup(var.lifecycle_policy, "transition_to_primary_storage_class", null) == null ? true :
      lookup(var.lifecycle_policy, "transition_to_primary_storage_class") == "AFTER_1_ACCESS"
    )
    error_message = "transition_to_primary_storage_class must be \"AFTER_1_ACCESS\""
  }

  validation {
    condition = var.lifecycle_policy == null ? true : (
      lookup(var.lifecycle_policy, "transition_to_archive", null) == null ? true :
      lookup(var.lifecycle_policy, "transition_to_ia", null) != null
    )
    error_message = "transition_to_archive requires transition_to_ia to be set"
  }
}

variable "protection" {
  description = <<-EOT
Configuration block for EFS file system protection settings. Supports the following settings:

<ul><li>`replication_overwrite`: (Optional) Indicates whether the destination file system can overwrite the source file system.
  Valid values: 
  <ul><li>`"ENABLED"`: Allows the destination file system to overwrite the source file system</li>
  <li>`"DISABLED"`: Prevents the destination file system from overwriting the source file system</li></ul>
</li></ul>
EOT
  type = object({
    replication_overwrite = optional(string)
  })

  default = null

  validation {
    condition     = var.protection == null ? true : var.protection.replication_overwrite == null ? true : contains(["ENABLED", "DISABLED"], var.protection.replication_overwrite)
    error_message = "replication_overwrite must be either \"ENABLED\" or \"DISABLED\""
  }
}

variable "performance_mode" {
  description = "The file system performance mode. Can be either `\"generalPurpose\"` or `\"maxIO\"`. Defaults to `\"generalPurpose\"`"
  type        = string
  default     = "generalPurpose"

  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Performance mode must be either \"generalPurpose\" or \"maxIO\"."
  }
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, to provision for the file system. Only applicable with `throughput_mode` set to `\"provisioned\"`"
  type        = number
  default     = null

  validation {
    condition     = var.provisioned_throughput_in_mibps == null ? true : var.provisioned_throughput_in_mibps >= 1
    error_message = "Provisioned throughput must be greater than or equal to 1 MiB/s"
  }

  validation {
    condition     = var.provisioned_throughput_in_mibps == null ? true : var.provisioned_throughput_in_mibps <= 10240
    error_message = "Provisioned throughput cannot exceed 10240 MiB/s (10 GiB/s)"
  }
}

variable "throughput_mode" {
  description = <<-EOT
Throughput mode for the file system. Valid values: `"bursting"`, `"provisioned"`, or `"elastic"`.
When using `"provisioned"`, also set `provisioned_throughput_in_mibps`". Deffults to `"bursting"`
EOT
  type        = string
  default     = "bursting"

  validation {
    condition     = contains(["bursting", "provisioned", "elastic"], var.throughput_mode)
    error_message = "Throughput mode must be one of: \"bursting\", \"provisioned\", or \"elastic\""
  }
}

variable "enable_automatic_backups" {
  description = "If `true`, automatic backups will be enabled for the file system. Defaults to `false`"
  type        = bool
  default     = false
}

variable "replication_configuration" {
  description = <<-EOT
Configuration block for EFS replication configuration. Supports the following settings:

<ul><li>`region`: (Optional) The AWS Region to replicate the file system to. Must be different from the source file system's region</ul></li>

<ul><li>`availability_zone_name`: (Optional) The availability zone in which the replica should be created. If specified, the replica will be 
  created with One Zone storage. If omitted, regional storage will be used</ul></li>

<ul><li>`file_system_id`: (Optional) The ID of an existing file system to use as the destination for replication. If not specified, 
  a new file system will be created with default settings</ul></li>

<ul><li>`kms_key_id`: (Optional) The ARN, ID alias, or alias ARN of the AWS KMS key used to encrypt the destination file system.
  The default KMS key for EFS `"/aws/elasticfilesystem"` will be used</ul></li>
EOT
  type = object({
    region                 = optional(string)
    availability_zone_name = optional(string)
    file_system_id         = optional(string)
    kms_key_id             = optional(string)
  })

  default = null
}

variable "access_points" {
  description = <<-EOT
A map of access points to create for the file system. Each access point supports the following settings:

<ul><li>`ac_name`</ul></li>: (Optional) A descriptive name for the access point.</ul></li>

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
  type = map(object({
    ac_name = optional(string)
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

  default = null
}

variable "mount_targets" {
  description = <<-EOT
Configuration block for EFS mount targets. Accepts a list of objects with the following settings:

<ul><li>`subnet_id`: (Required) The ID of the subnet to add the mount target in</li>
<li>`ip_address`: (Optional) The IPv4 address within the subnet's CIDR range where the mount target will be created</li>
<li>`security_groups`: (Optional) A list of security group IDs (up to 5 items) to associate with the mount target</li></ul>  
EOT
  type = list(object({
    subnet_id       = string
    ip_address      = optional(string)
    security_groups = optional(list(string))
  }))

  default = null
}

variable "policy_configuration" {
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
  type = object({
    version                   = optional(string)
    override_policy_documents = optional(list(any))
    policy_id                 = optional(string)
    source_policy_documents   = optional(list(string))

    statements = optional(list(object({
      sid     = optional(string)
      effect  = optional(string)
      actions = optional(list(string))

      condition = optional(object({
        test     = string
        variable = string
        values   = list(string)
      }))

      not_actions = optional(list(any))

      not_principals = optional(list(object({
        identifiers = list(string)
        type        = string
      })))

      not_resources = optional(list(string))

      principals = optional(list(object({
        identifiers = list(string)
        type        = string
      })))

      resources = optional(list(string))
    })))

    bypass_policy_lockout_safety_check = optional(bool)
  })
  default = null

  validation {
    condition     = var.policy_configuration == null ? true : contains(["2008-10-17", "2012-10-17"], var.policy_configuration.version)
    error_message = "IAM policy document version must be either \"2008-10-17\" or \"2012-10-17\""
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}