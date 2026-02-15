# provider "kubernetes" {
#     config_context_cluster   = "minikube"
# }
resource "kubernetes_replication_controller" "mysql" {
  metadata {
    name = "terraform-db-rs"
    namespace = "k8s-ns-by-tf" 
  }

  spec {
    replicas = 1
    selector = {
      app = "db"
    }
    template {
      metadata {
        labels = {
          app = "db"
        }
        
      }

      spec {
        container {
          image = "mysql:5.7"
          name  = "mydb-con"
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value = "root"
            
             }
             env {
            name= "MYSQL_USER"
            value = "user"
            
             }
             env {
           name =  "MYSQL_PASSWORD"
            value = "password"
             }
             env {
           name = "MYSQL_DATABASE"
            value = "terraform"
            
             }
         }   
        }
    }   
  }
}