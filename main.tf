data "aws_availability_zones" "available" {
  state = "available"
}

# resource "aws_ebs_volume" "vol_1" {
#   availability_zone = data.aws_availability_zones.available.names[0]
#   size              = 1

#   tags = {
#     Name = "test_vol1"
#   }
# }

### Create S3 bucket for website
resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "static_web" {
  bucket = aws_s3_bucket.web_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.web_bucket.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "upload_object" {
  for_each = fileset("html/", "*")
  bucket = aws_s3_bucket.web_bucket.id
  key = each.value
  source = "html/${each.value}"
  etag = filemd5("html/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "static_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  #policy = data.aws_iam_policy_document.allow_pub_access.json
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.web_bucket.arn}/*"
      },
    ]
  })
}

data "aws_iam_policy_document" "allow_pub_access" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_bucket.arn}/*"]
  }
}

######


# resource "aws_ebs_volume" "vol_1_member_account" {
#   provider = aws.central_backup
#   availability_zone = data.aws_availability_zones.available.names[0]
#   size              = 1

#   tags = {
#     Name = "test_vol1"
#   }
# }