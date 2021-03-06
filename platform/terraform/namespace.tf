
resource "kubernetes_namespace" "metaservice" {
  metadata {
    name = "metaservice"
  }
}

