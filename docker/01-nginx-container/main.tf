resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  name = "demo-terraform-nginx"
  image = docker_image.nginx_image.image_id
  rm   = true
  ports {
    internal = 80
    external = 8081
  }
  labels {
    label = "Terraform"
    value = "True"
  }
}