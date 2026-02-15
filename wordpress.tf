# provider "kubernetes" {
#     config_context_cluster   = "minikube"
# }
resource "kubernetes_replication_controller" "wordpress" {
  metadata {
    name = "terraform-wordpress-rc"
    namespace = "k8s-ns-by-tf" 
  }

  spec {
    replicas = 1
    selector = {
      app = "wordpress"
    }
    template {
      metadata {
        labels = {
          app = "wordpress"
        }
        
      }

      spec {
        container {
          image = "wordpress:4.8-apache"
          name  = "mywordpress-con"
          
         }   
        }
    }   
  }
}

resource "kubernetes_service" "wordpress_port" {
  metadata {
    name = "terraform-service"
    namespace = "k8s-ns-by-tf"
  }
  spec {
    selector = {
      app = "wordpress"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
    }

    type = "NodePort"
  }
}