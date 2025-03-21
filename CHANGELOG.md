# Changelog

Significant modifications to this project will be recorded in this file.

## 1.0.0 (2025-03-21)


### Features

* Add complete example showcasing all EFS module features ([a313129](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/a31312956e72ed71abdb945fec76a790b5d03e84))
* Add default example for basic EFS module usage ([a3c4dc3](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/a3c4dc3614e405dce882c4848cd508ec331b508a))
* Add example security group configuration for EFS mount targets ([b6b3fcf](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/b6b3fcf99217db8d5e2617eac5da2f18391a42aa))
* **devcontainer:** Add AWS CLI, Terraform, and related tools to the dev container ([577dd66](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/577dd6644d5352e1e9e97ec8d03ee26d4c2f4f71))
* **devcontainer:** Add Docker-in-Docker to the dev container ([6ed84f5](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/6ed84f559f2e47cafe76045ff928d8f6f46a3b19))
* **module:** Add initial EFS module configuration ([604b6c6](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/604b6c657d40e7d4cbcd98db6f19c26dc5f71b36))
* **module:** Implement EFS security group management ([d1139ee](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/d1139eeaedcd298d2ccc418aaef8d6142c3a82dc))
* **outputs:** Add EFS module outputs ([beebc83](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/beebc83fe3b131fa2d42605234c4e13890eeb269))
* **timeouts:** Add dynamic timeouts for replication and mount targets ([c3510fa](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/c3510fa9cee8ce4790d4228bfc433f5a9284ccde))
* **validation:** Add EFS access point POSIX validation rules ([4df42f9](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/4df42f9c2f6ad6cd4784eab57bdef73596f39d30))
* **variables:** Add initial EFS module variables ([aee4b8b](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/aee4b8b8d02a8760a68df5f4c2b46ff46033cc41))
* **variables:** Add security group configuration and update defaults ([f242f88](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/f242f881f878ad0aad6d05e95e96970d59268179))


### Bug Fixes

* Fix description in EFS example module documentation ([1a97316](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/1a973161fe3968d4b2eaa0683e8182298a66eedd))
* **module:** Remove unnecessary dynamic blocks for `timeouts` ([26b5655](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/26b56555fcf00180c0dfbc79159da2ad9a1e2255))
* **outputs:** Handle null values for access points outputs ([3c5b0f2](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/3c5b0f273f8b4f352ff1bdb066c4926f92b46b2b))
* **outputs:** Improve mount targets count calculation ([01b311f](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/01b311ffca24e75ef2ec74db487d6775a221cabd))
* **variables:** Enable EFS encryption by default ([61c4e04](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/61c4e04fa38c9bd0f8c448564496f0c6257a6ded))


### Reverts

* Remove terraform-docs config files from `.gitignore` ([db47485](https://github.com/stanislavzabarylo/terraform-aws-efs-module/commit/db4748548418f30105b9b202dc3868cf5a3f708c))
