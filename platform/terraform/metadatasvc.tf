resource "kubernetes_service" "metasvc" {
  metadata {
    name = "metadata-svc"
    namespace = "metaservice"
  }
  spec {

    selector = {
      App = "metadata-pod"
    }
    port {
      port = 8080
      target_port = 8080
      protocol = "TCP"
      node_port = 32323
    }
    type = "NodePort"
  }
}
