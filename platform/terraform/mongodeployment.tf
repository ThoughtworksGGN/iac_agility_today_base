resource "kubernetes_deployment" "mongodb" {
  metadata {
    name = "mongo"
    namespace = "metaservice"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongo-pod"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongo-pod"
        }
      }
      spec {
        container {
          name = "mongo-container"
          image = "mongo:4.2.6"
          port {
            container_port = 27017
          }
        }
      }
    }
  }
}
