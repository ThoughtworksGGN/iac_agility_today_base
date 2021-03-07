resource "kubernetes_deployment" "metaservice" {
  metadata {
    namespace = "metaservice"
    name = "metadata"
    labels = {
      App = "metadata-pod"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "metadata-pod"
      }
    }
    template {
      metadata {
        labels = {
          App = "metadata-pod"
        }
      }
      spec {
        container {
          image = "sunitparekh/metadata:v2.0"
          name  = "metadata"
          env {
            name = "MONGODB_URI"
            value = "mongodb://mongo/metadata"
          }
          env {
            name = "info.app.version"
            value = "10.0.0"
          }
          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = "8080"
            }
            initial_delay_seconds = 60
            period_seconds = 5
          }
          liveness_probe {
            http_get {
              path = "/actuator/info"
              port = "8080"
            }
            initial_delay_seconds = 60
            period_seconds = 5
          }

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}



