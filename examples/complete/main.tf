locals {
  # Define availability zones
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  created_by         = "Terraform"
  # VPC CIDR block for network configuration
  cidr_block      = "10.0.0.0/16"
  posix_user_name = "example-posix-user"
}

# Get list of available AZs in current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Reference existing IAM role for EFS access
data "aws_iam_role" "example" {
  name = "TerraformEFSModuleCompleteExample"
}

# Create VPC for EFS resources
resource "aws_vpc" "example" {
  cidr_block = local.cidr_block

  tags = {
    CreatedBy = local.created_by
  }
}

# Create subnets across multiple AZs for high availability
resource "aws_subnet" "example" {
  count = 2

  vpc_id            = aws_vpc.example.id
  cidr_block        = cidrsubnet(local.cidr_block, 8, count.index)
  availability_zone = local.availability_zones[count.index]

  tags = {
    CreatedBy = local.created_by
  }
}

# Security group for EFS mount targets
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    CreatedBy = local.created_by
  }
}

# Main EFS module configuration with comprehensive features
module "efs_complete" {
  source = "../.."

  # Basic EFS configuration
  name                     = "example-efs"
  creation_token           = "example-creation-token"
  encrypted                = true
  enable_automatic_backups = true

  # Configure lifecycle management for cost optimization
  lifecycle_policy = {
    transition_to_ia                    = "AFTER_7_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  # Configure access points for application-specific entry points
  access_points = {
    (local.posix_user_name) = {
      ac_name = local.posix_user_name
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002, 1003, 1004]
      }

      root_directory = {
        path = "/${local.posix_user_name}"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  # Configure mount targets in multiple AZs for high availability
  mount_targets = [
    {
      subnet_id       = aws_subnet.example[0].id
      security_groups = [aws_security_group.example.id]
      timeouts = {
        create = "50m"
        delete = "40m"
      }
    },
    {
      subnet_id       = aws_subnet.example[1].id
      security_groups = [aws_security_group.example.id]
      timeouts = {
        create = "40m"
        delete = "30m"
      }
    }
  ]

  # Configure cross-region replication for disaster recovery in other region
  replication_configuration = {
    region                 = "us-west-1"
    availability_zone_name = "us-west-1b"
    timeouts = {
      create = "1h"
      delete = "30m"
    }
  }

  # Configure IAM policy for EFS access control
  policy_configuration = {
    version   = "2012-10-17"
    policy_id = "policy-example-id"

    statements = [
      {
        sid = "ECSTasksReadWriteAccess"
        actions = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ]
        principals = [
          {
            type        = "AWS"
            identifiers = [data.aws_iam_role.example.arn]
          }
        ]
      }
    ]

    bypass_policy_lockout_safety_check = false
  }

  tags = {
    CreatedBy = local.created_by
  }
}