provider "kubernetes" {
  host = "https://192.168.64.12:8443"

  client_certificate     = "${file("~/.kube/client-cert.pem")}"
  client_key             = "${file("~/.kube/client-key.pem")}"
  cluster_ca_certificate = "${file("~/.kube/client-ca-cert.pem")}"
}
