locals {
  default_token = "terraform-${formatdate("YYYYMMDDhhmmss", timestamp())}-${substr(uuid(), 0, 12)}"

  creation_token = (
    var.encrypted ? (
      coalesce(var.creation_token, local.default_token)
    ) : null
  )
}

data "aws_iam_policy_document" "this" {
  count = try(var.policy_configuration != null && var.policy_configuration.statements != null, false) ? 1 : 0

  override_policy_documents = var.policy_configuration.override_policy_documents
  policy_id                 = var.policy_configuration.policy_id
  source_policy_documents   = var.policy_configuration.source_policy_documents

  dynamic "statement" {
    for_each = try(var.policy_configuration != null ? coalesce(var.policy_configuration.statements, []) : [], [])

    content {
      actions = statement.value.actions

      dynamic "condition" {
        for_each = statement.value.condition != null ? [statement.value.condition] : []
        content {
          test     = condition.value.condition.test
          values   = condition.value.condition.values
          variable = condition.value.condition.variable
        }
      }

      effect      = statement.value.effect
      not_actions = statement.value.not_actions

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      resources = statement.value.resources
      sid       = statement.value.sid
    }
  }

  version = var.policy_configuration.version != null ? var.policy_configuration.version : "2012-10-17"
}

resource "aws_efs_file_system" "this" {
  availability_zone_name          = var.availability_zone_name
  creation_token                  = local.creation_token
  encrypted                       = var.kms_key_id != null ? true : var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = try([for k, v in var.lifecycle_policy : { (k) = v }], [])

    content {
      transition_to_ia                    = try(lifecycle_policy.value.transition_to_ia, null)
      transition_to_archive               = try(lifecycle_policy.value.transition_to_archive, null)
      transition_to_primary_storage_class = try(lifecycle_policy.value.transition_to_primary_storage_class, null)
    }
  }

  dynamic "protection" {
    for_each = var.protection != null ? [var.protection] : []

    content {
      replication_overwrite = protection.value.replication_overwrite
    }
  }

  tags = merge(
    { Name = var.name },
    var.tags,
  )
}

resource "aws_efs_backup_policy" "this" {
  count          = var.enable_automatic_backups ? 1 : 0
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = var.enable_automatic_backups ? "ENABLED" : "DISABLED"
  }
}

resource "aws_efs_replication_configuration" "this" {
  count                 = var.replication_configuration != null ? 1 : 0
  source_file_system_id = aws_efs_file_system.this.id

  dynamic "destination" {
    for_each = try(var.replication_configuration, null) != null ? [var.replication_configuration] : []

    content {
      region                 = destination.value.region
      availability_zone_name = destination.value.availability_zone_name
      file_system_id         = destination.value.file_system_id
      kms_key_id             = destination.value.kms_key_id != null ? destination.value.kms_key_id : "alias/aws/elasticfilesystem"
    }
  }

  timeouts {
    create = coalesce(try(var.replication_configuration.timeouts.create, null), "20m")
    delete = coalesce(try(var.replication_configuration.timeouts.delete, null), "20m")
  }
}

resource "aws_efs_access_point" "this" {
  for_each = var.access_points != null ? var.access_points : {}

  file_system_id = aws_efs_file_system.this.id

  dynamic "posix_user" {
    for_each = try(each.value.posix_user, null) != null ? [each.value.posix_user] : []

    content {
      gid            = posix_user.value.gid
      secondary_gids = posix_user.value.secondary_gids
      uid            = posix_user.value.uid
    }
  }

  dynamic "root_directory" {
    for_each = try(each.value.root_directory, null) != null ? [each.value.root_directory] : []

    content {
      creation_info {
        owner_gid   = root_directory.value.creation_info.owner_gid
        owner_uid   = root_directory.value.creation_info.owner_uid
        permissions = root_directory.value.creation_info.permissions
      }

      path = root_directory.value.path
    }
  }

  tags = merge(
    { Name = var.name },
    var.tags,
  )
}

resource "aws_efs_mount_target" "this" {
  count = var.mount_targets != null ? length(var.mount_targets) : 0

  file_system_id  = aws_efs_file_system.this.id
  ip_address      = var.mount_targets[count.index].ip_address
  security_groups = var.mount_targets[count.index].security_groups
  subnet_id       = var.mount_targets[count.index].subnet_id

  timeouts {
    create = coalesce(try(var.mount_targets[count.index].timeouts.create, null), "30m")
    delete = coalesce(try(var.mount_targets[count.index].timeouts.delete, null), "10m")
  }
}

resource "aws_efs_file_system_policy" "this" {
  count = var.policy_configuration != null ? 1 : 0

  file_system_id                     = aws_efs_file_system.this.id
  policy                             = data.aws_iam_policy_document.this[0].json
  bypass_policy_lockout_safety_check = var.policy_configuration.bypass_policy_lockout_safety_check != null ? var.policy_configuration.bypass_policy_lockout_safety_check : false
}