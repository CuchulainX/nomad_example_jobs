job "docker-iis" {
  datacenters = ["dc1"]

  group "windows" {
    constraint {
      attribute = "${attr.kernel.name}"
      operator  = "="
      value     = "windows"
    }

    network {
      port "www" {
        to = 80
      }
    }

    service {
      name = "windows-docker-iis"
      tags = ["windows","iis"]
      port = "www"

      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "iis-site" {
      driver = "docker"

      config {
        image = "voiselle/windows-test:v1"
        ports = ["www"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
