### Create S3 bucket for website
# resource "aws_s3_bucket" "web_bucket" {
#   bucket        = var.bucket_name
#   force_destroy = true
# }

# resource "aws_s3_bucket_website_configuration" "static_web" {
#   bucket = aws_s3_bucket.web_bucket.id
#   index_document {
#     suffix = "index.html"
#   }
#   error_document {
#     key = "error.html"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "public_access_block" {
#   bucket                  = aws_s3_bucket.web_bucket.id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_object" "upload_object" {
#   for_each     = fileset("html/", "*")
#   bucket       = aws_s3_bucket.web_bucket.id
#   key          = each.value
#   source       = "html/${each.value}"
#   etag         = filemd5("html/${each.value}")
#   content_type = "text/html"
# }

# resource "aws_s3_bucket_policy" "static_bucket_policy" {
#   bucket = aws_s3_bucket.web_bucket.id
#   #policy = data.aws_iam_policy_document.allow_pub_access.json
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "IPAllow"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = ["s3:GetObject"]
#         Resource  = "${aws_s3_bucket.web_bucket.arn}/*"
#       },
#     ]
#   })
#   depends_on = [ aws_s3_bucket.web_bucket ]
# }

# data "aws_iam_policy_document" "allow_pub_access" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.web_bucket.arn}/*"]
#   }
# }

######


resource "aws_ebs_volume" "vol_test" {
  availability_zone = "eu-central-1b"
  size              = 4
  tags = {
    Name = "test_vol1"
  }
}

##### Atlantis
# data "aws_secretsmanager_secret_version" "atlantis_github_token" {
#   secret_id = "GITHUB_TOKEN"
# }
# data "aws_ssm_parameter" "github_user" {
#   name = "GITHUB_USER"
# }
# data "aws_iam_role" "atlantis_task_role" {
#   name = "Atlantis-fargate-role"
# }

# module "atlantis" {
#   source  = "terraform-aws-modules/atlantis/aws"

#   name = "atlantis"

#   # ECS Container Definition
#   atlantis = {
#     environment = [
#       {
#         name  = "ATLANTIS_GH_USER"
#         value = data.aws_ssm_parameter.github_user.value
#       },
#       {
#         name  = "ATLANTIS_REPO_ALLOWLIST"
#         value = "https://github.com/mastercam123/iac-aws-app"
#       },
#     ]
#     secrets = [
#       {
#         name      = "ATLANTIS_GH_TOKEN"
#         valueFrom = data.aws_secretsmanager_secret_version.secret_string
#       },
#       {
#         name      = "ATLANTIS_GH_WEBHOOK_SECRET"
#         valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F"
#       },
#     ]
#   }

#   # ECS Service
#   service = {
#     # Provide Atlantis permission necessary to create/destroy resources
#     tasks_iam_role_policies = {
#       AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
#     }
#   }
#   service_subnets = ["subnet-089be39d7a382f5bf", "subnet-0fb6f411435ff2a8c", "subnet-01c82d3491e1dd670"]
#   vpc_id          = "vpc-091dd998ae50d2ffa"

#   # ALB
#   alb_subnets             = ["subnet-0ef537a8db928a348", "subnet-0836f518294aa2fe3", "subnet-0c9276b9d1237eb00"]
#   certificate_domain_name = "example.com"
#   route53_zone_id         = "Z2ES7B9AZ6SHAE"

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }