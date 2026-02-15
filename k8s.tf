resource "kubernetes_namespace" "example" {
  metadata {
    name = "k8s-ns-by-tf"
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
    namespace = "k8s-ns-by-tf"
  }
  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"
        }
      }
    }
   }   
}

resource "kubernetes_service" "nginx_port" {
  metadata {
    name = "terraform-example"
    namespace = "kubernetes_namespace.example.metadata[0].name"
  }
  spec {
    selector = {
      test = "MyExampleApp"
    }
    session_affinity = "ClientIP"
    port {
      port = 80
    }

    type = "NodePort"
  }
}