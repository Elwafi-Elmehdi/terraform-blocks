variable "bucket_name" {
  description = "Bucket name Must be unique"
  default     = "d5aw5d5aw5dq8"
  type        = string
}
variable "index_file_path" {
  default     = "./data/index.html"
  description = "The Path for Index File"
  type        = string
}