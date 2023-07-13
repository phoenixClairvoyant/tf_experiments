
resource "docker_image" "rct_static_web" {
  name         = "static_webapp_image"
  keep_locally = true
  build {
    context    = "../webapp"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "nginx" {
  image = docker_image.rct_static_web.image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8080
  }
}
