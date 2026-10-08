resource "aws_s3_bucket" "s3_bucket" {
  bucket = "aryaan-tfstate-threat-composer-683803166135-eu-west-2-an"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}