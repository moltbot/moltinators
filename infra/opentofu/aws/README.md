# OpenTofu (AWS S3 Image Bucket)

Goal: use the CLAWDINATOR S3 bucket for images, plus create the VM Import role and attach import permissions to the CI IAM user.

Prereqs:
- AWS credentials with permissions to manage IAM (use your homelab-admin key locally).

Usage:
- export AWS_ACCESS_KEY_ID=...
- export AWS_SECRET_ACCESS_KEY=...
- export AWS_REGION=eu-central-1
- tofu init
- tofu apply

Outputs:
- `bucket_name`
- `aws_region`
- `ci_user_name`
- `access_key_id`
- `secret_access_key`

CI wiring:
- Set GitHub Actions secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`
  - `S3_BUCKET`
