provider "kubernetes" {
  host = "https://${var.minikube_ip}:8443"

  client_certificate     = "${file("~/.kube/client-cert.pem")}"
  client_key             = "${file("~/.kube/client-key.pem")}"
  cluster_ca_certificate = "${file("~/.kube/client-ca-cert.pem")}"
}

//Note: Uncomment below if you want to run it just locally
//provider "kubernetes" {
//  config_path    = "~/.kube/config"
//  config_context = "minikube"
//}