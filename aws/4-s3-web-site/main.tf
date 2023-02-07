resource "aws_s3_bucket" "name" {
  bucket = var.bucket_name
  
}

resource "aws_s3_bucket_acl" "name" {
  
}
resource "aws_s3_bucket_website_configuration" "name" {
  
}