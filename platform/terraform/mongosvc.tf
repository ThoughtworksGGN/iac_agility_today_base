resource "kubernetes_service" "mongosvc" {
  metadata {
    name = "mongo"
    namespace = "metaservice"
  }
  spec {
    selector =  {
      app = "mongo-pod"
    }
    port {
      port = 27017
      protocol = "TCP"
      target_port = "27017"
    }
    type = "ClusterIP"

  }
}
