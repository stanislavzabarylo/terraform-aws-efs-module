locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  created_by         = "Terraform"
  cidr_block         = "10.0.0.0/16"
  posix_user_name    = "example-posix-user"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_role" "example" {
  name = "TerraformEFSModuleCompleteExample"
}

resource "aws_vpc" "example" {
  #checkov:skip=CKV2_AWS_11:Not needed as this is a example VPC and flow logging is not required for demonstration purposes
  #checkov:skip=CKV2_AWS_12:Not needed as a separate security group is created and used for EFS mount targets, not the default SG    
  cidr_block = local.cidr_block

  tags = {
    CreatedBy = local.created_by
  }
}

resource "aws_subnet" "example" {
  count = 2

  vpc_id            = aws_vpc.example.id
  cidr_block        = cidrsubnet(local.cidr_block, 8, count.index)
  availability_zone = local.availability_zones[count.index]

  tags = {
    CreatedBy = local.created_by
  }
}

resource "aws_security_group" "example" {
  #checkov:skip=CKV2_AWS_5:This checkov check are not needed since the security group attached to EFS mount targets
  name        = "example-sg"
  vpc_id      = aws_vpc.example.id
  description = "Example EFS mount target security group"

  tags = {
    CreatedBy = local.created_by
  }
}

# Main EFS module configuration with comprehensive features
module "efs_complete" {
  source = "../.."

  name                     = "example-efs"
  creation_token           = "example-creation-token"
  encrypted                = true
  enable_automatic_backups = true
  throughput_mode          = "bursting"
  performance_mode         = "generalPurpose"

  # Set to desired throughput in MiB/s when throughput_mode is "provisioned"   
  # provisioned_throughput_in_mibps = 256

  # Uncomment and specify availability_zone_name to use One Zone storage
  # This reduces costs and stores data in only one AZ
  # availability_zone_name = "us-west-2a"

  # Custom KMS Key Configuration  
  # Uncomment and specify kms_key_id to use a custom KMS key for encryption
  # kms_key_id = "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"

  # Lifecycle Management Configuration
  lifecycle_policy = {
    # Move files to IA storage class after 7 days of no access
    transition_to_ia = "AFTER_7_DAYS"
    # Move files back to standard storage after being accessed
    transition_to_primary_storage_class = "AFTER_1_ACCESS"

    # Enable archival storage for rarely accessed files
    # Provides ~90% cost savings but with higher retrieval times
    # transition_to_archive = "AFTER_180_DAYS"
  }

  # Access Points Configuration
  access_points = {
    (local.posix_user_name) = {
      name = local.posix_user_name
      # Configure POSIX user identity for all operations through this access point
      posix_user = {
        gid            = 1001               # Primary group ID
        uid            = 1001               # User ID
        secondary_gids = [1002, 1003, 1004] # Additional group memberships
      }

      # Configure root directory settings for this access point
      root_directory = {
        path = "/${local.posix_user_name}"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "0755" # -rwxr-xr-x permissions
        }
      }
    }
  }

  # Mount Targets Configuration
  mount_targets = [
    {
      subnet_id       = aws_subnet.example[0].id
      security_groups = [aws_security_group.example.id]
      timeouts = {
        # Custom timeout for mount target creation and deletion
        create = "50m"
        delete = "40m"
      }
    },
    {
      subnet_id       = aws_subnet.example[1].id
      security_groups = [aws_security_group.example.id]
    }
  ]

  # Cross-Region Replication Configuration
  replication_configuration = {
    region                 = "us-west-1"
    availability_zone_name = "us-west-1b"
    timeouts = {
      create = "1h"
      delete = "30m"
    }
  }

  # Data Protection Configuration
  protection = {
    replication_overwrite = "ENABLED"
  }

  # IAM Policy Configuration
  policy_configuration = {
    version   = "2012-10-17"
    policy_id = "policy-example-id"

    statements = [
      {
        # For example, allow ECS tasks to mount and write to the file system
        sid = "ECSTasksReadWriteAccess"
        actions = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ]
        principals = [
          {
            type        = "AWS"
            identifiers = [data.aws_iam_role.example.arn] # Reference to existing IAM role
          }
        ]
      }
    ]

    # Safety feature to prevent locking yourself out of the file system
    bypass_policy_lockout_safety_check = false
  }

  # Metadata tags to the EFS file system
  tags = {
    CreatedBy = local.created_by
  }
}
