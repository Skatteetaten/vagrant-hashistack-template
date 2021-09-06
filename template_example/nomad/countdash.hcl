job "countdash" {
  datacenters = ["dc1"]
  group "api" {
    network {
      mode = "bridge"
    }

    service {
      name = "count-api"
      port = "9001"

      connect {
        sidecar_service {}
      }
      check {
        expose   = true
        name     = "api-alive"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "web" {
      driver = "docker"
      artifact {
        source = "s3::http://127.0.0.1:9000/dev/tmp/container-image.tar"
        options {
          aws_access_key_id     = "minioadmin"
          aws_access_key_secret = "minioadmin"
        }
      }
      config {
        load = "container-image.tar"
        # This image is built in this repo and can thus be tested
        image = "ghcr.io/skatteetaten/vagrant-hashistack-template"
      }
    }
  }

  group "dashboard" {
    network {
      mode ="bridge"
      port "http" {
        static = 9002
        to     = 9002
      }
    }

    service {
      name = "count-dashboard"
      port = "9002"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port = 8080
            }
          }
        }
      }
      check {
        expose   = true
        name     = "dashboard-alive"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "dashboard" {
      driver = "docker"
      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }
      config {
        # This image is prebuilt on a registry
        image = "hashicorpnomad/counter-dashboard:v3"
      }
    }
  }
}
