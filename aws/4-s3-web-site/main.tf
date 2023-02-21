resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

}
resource "aws_s3_object" "website_index_file" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  acl    = "public-read"
  source = var.index_file_path
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
  bucket = aws_s3_bucket.website_bucket.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = templatefile("./data/s3-policy.json", { bucket = var.bucket_name })
}

resource "aws_s3_bucket_website_configuration" "name" {
  bucket = aws_s3_bucket.website_bucket.bucket
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}