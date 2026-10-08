# s3 bucket 
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "aryaan-tfstate-threat-composer-683803166135-eu-west-2-an"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ecr 
resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
