# Infraestructura como Código sobre Kubernetes con Terraform

> **Trabajo de Fin de Grado (TFG) - 2º ASIR**  
> Autor: Iván Loor

## Índice

- [Descripción del Proyecto](#-descripción-del-proyecto)
- [Objetivos](#-objetivos)
- [Tecnologías Utilizadas](#-tecnologías-utilizadas)
- [Arquitectura del Sistema](#️-arquitectura-del-sistema)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Configuración](#-instalación-y-configuración)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Despliegue de Infraestructura](#-despliegue-de-infraestructura)
- [Ejemplos de Uso](#-ejemplos-de-uso)
- [Comandos Útiles](#-comandos-útiles)
- [Conclusiones](#-conclusiones)
- [Bibliografía](#-bibliografía)
- [Licencia](#-licencia)

---

## Descripción del Proyecto

Este proyecto implementa una infraestructura completa basada en **Kubernetes**, utilizando **Minikube** como entorno local de desarrollo sobre Windows. La infraestructura se gestiona mediante **Terraform** (Infrastructure as Code), permitiendo un despliegue automatizado, predecible y reproducible.

El proyecto incluye el despliegue de:
- **Nginx** como servidor web
- **MySQL** como base de datos
- **WordPress** como sistema de gestión de contenidos

Todo el código de infraestructura está versionado con **Git** y alojado en **GitHub**, siguiendo las mejores prácticas de DevOps.

---

## Objetivos

-  Implementar una infraestructura funcional de Kubernetes en entorno local
-  Configurar Docker y Minikube correctamente en Windows
-  Automatizar el despliegue de aplicaciones mediante Terraform (IaC)
-  Desplegar aplicaciones containerizadas dentro del clúster Kubernetes
-  Comprender y aplicar conceptos de orquestación de contenedores
-  Documentar todos los pasos necesarios para su implementación

---

## Tecnologías Utilizadas

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| **Terraform** | Latest | Infraestructura como Código (IaC) |
| **Kubernetes** | v2.11.0 | Orquestación de contenedores |
| **Minikube** | Latest | Clúster local de Kubernetes |
| **Docker** | Latest | Motor de contenedores |
| **Git** | Latest | Control de versiones |
| **GitHub** | - | Repositorio remoto |
| **Nginx** | 1.21.6 | Servidor web |
| **MySQL** | 5.7 | Base de datos |
| **WordPress** | 4.8-apache | CMS |

---

## Arquitectura del Sistema

```
┌─────────────────────────────────────────────────┐
│              Windows Host Machine                │
│                                                   │
│  ┌───────────────────────────────────────────┐  │
│  │            Minikube (Docker)               │  │
│  │                                             │  │
│  │  ┌─────────────────────────────────────┐  │  │
│  │  │    Kubernetes Cluster (k8s-ns-by-tf) │  │  │
│  │  │                                       │  │  │
│  │  │  ┌──────────┐  ┌──────────┐         │  │  │
│  │  │  │  Nginx   │  │WordPress │         │  │  │
│  │  │  │  Pods    │  │   Pods   │         │  │  │
│  │  │  │ (x2)     │  │  (x1)    │         │  │  │
│  │  │  └──────────┘  └──────────┘         │  │  │
│  │  │                     │                │  │  │
│  │  │                     ▼                │  │  │
│  │  │              ┌──────────┐           │  │  │
│  │  │              │  MySQL   │           │  │  │
│  │  │              │   Pod    │           │  │  │
│  │  │              │  (x1)    │           │  │  │
│  │  │              └──────────┘           │  │  │
│  │  │                                      │  │  │
│  │  │  Services: NodePort (80)            │  │  │
│  │  └──────────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────┘  │
│                                                   │
│  Terraform CLI ──► Kubernetes Provider            │
└───────────────────────────────────────────────────┘
```

---

## Requisitos Previos

### Sistema Operativo
- Windows 7, 8, 8.1, 10 o superior
- macOS 10.9 (Mavericks) o posterior
- Linux (Ubuntu, Fedora, Debian, etc.)

### Software Requerido
- [Git](https://git-scm.com/downloads) - Control de versiones
- [Terraform](https://developer.hashicorp.com/terraform) - IaC
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) - Kubernetes local
- [Docker](https://www.docker.com/) - Motor de contenedores
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - CLI de Kubernetes

---

## Instalación y Configuración

### Instalación de Git

```bash
# Descargar desde: https://git-scm.com/downloads/win
# Ejecutar el instalador y seguir el asistente

# Verificar instalación
git --version
```

### Instalación de Terraform

```powershell
# Descargar el binario desde: https://developer.hashicorp.com/terraform
# Extraer el archivo ZIP
# Mover terraform.exe a una carpeta (ej: C:\terraform)

# Añadir al PATH del sistema (PowerShell como Administrador)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\terraform", "Machine")

# Verificar instalación
terraform --version
```

### Instalación de Minikube

```powershell
# Crear carpeta para Minikube
New-Item -Path 'C:\minikube' -ItemType Directory -Force

# Descargar Minikube
Invoke-WebRequest -OutFile 'C:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe'

# Añadir al PATH
$oldPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
if ($oldPath.Split(';') -notcontains 'C:\minikube'){
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), 'Machine')
}

# Iniciar Minikube
minikube start --driver=docker

# Verificar instalación
minikube status
kubectl get po -A
```

### Configuración de Git y GitHub

```bash
# Configurar usuario
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Inicializar repositorio
git init

# Conectar con GitHub
git remote add origin https://github.com/tu-usuario/tu-repositorio.git

# Agregar archivos
git add .

# Confirmar cambios
git commit -m "Initial commit: Infrastructure as Code with Terraform"

# Subir a GitHub
git push -u origin main
```

---

## Estructura del Proyecto

```
proyecto-tfg/
│
├── providers.tf              # Configuración de proveedores (Kubernetes)
├── k8s.tf                    # Namespace, deployment y service de Nginx
├── resource.tf               # Replication Controller de MySQL
├── wordpress.tf              # Deployment y service de WordPress
├── variables.tf              # Variables de configuración (opcional)
├── terraform.tfstate         # Estado actual de la infraestructura
├── terraform.tfstate.backup  # Backup del estado anterior
├── .terraform.lock.hcl       # Lock file de dependencias
├── .terraform/               # Directorio de plugins y módulos
├── .git/                     # Control de versiones
├── .gitignore                # Archivos ignorados por Git
└── README.md                 # Este archivo
```

### Descripción de Archivos Principales

#### `providers.tf`
Define el proveedor de Kubernetes y su configuración de conexión con Minikube.

```hcl
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
```

#### `k8s.tf`
Crea el namespace y despliega Nginx con 2 réplicas.

#### `resource.tf`
Despliega un Replication Controller de MySQL con las credenciales configuradas.

#### `wordpress.tf`
Despliega WordPress y expone el servicio mediante NodePort en el puerto 80.

---

## Despliegue de Infraestructura

### Comandos Terraform

```bash
# 1. Inicializar Terraform (descarga providers)
terraform init

# 2. Validar la configuración
terraform validate

# 3. Ver plan de ejecución (qué se va a crear)
terraform plan

# 4. Aplicar cambios (desplegar infraestructura)
terraform apply
# Confirmar con: yes

# 5. Ver el estado actual
terraform show

# 6. Destruir toda la infraestructura
terraform destroy
# Confirmar con: yes
```

### Verificación del Despliegue

```bash
# Ver todos los pods
kubectl get pods -n k8s-ns-by-tf

# Ver deployments
kubectl get deployment -n k8s-ns-by-tf

# Ver replication controllers
kubectl get rc -n k8s-ns-by-tf

# Ver servicios
kubectl get services -n k8s-ns-by-tf

# Ver nodos
kubectl get nodes

# Abrir Dashboard de Kubernetes
minikube dashboard
```

---

## Ejemplos de Uso

### Acceder a WordPress

```bash
# Obtener la URL del servicio de WordPress
minikube service terraform-service -n k8s-ns-by-tf --url

# O abrir directamente en el navegador
minikube service terraform-service -n k8s-ns-by-tf
```

### Escalar Aplicaciones

```bash
# Escalar WordPress a 3 réplicas
kubectl scale rc/terraform-wordpress-rc --replicas=3 -n k8s-ns-by-tf

# Verificar
kubectl get pods -n k8s-ns-by-tf
```

### Ver Logs de un Pod

```bash
# Listar pods
kubectl get pods -n k8s-ns-by-tf

# Ver logs de un pod específico
kubectl logs <nombre-del-pod> -n k8s-ns-by-tf
```

---

## Comandos Útiles

### Comandos de Git

```bash
# Ver estado del repositorio
git status

# Ver historial de commits
git log --oneline

# Crear una nueva rama
git checkout -b feature/nueva-funcionalidad

# Fusionar ramas
git merge nombre-rama

# Actualizar desde GitHub
git pull origin main
```

### Comandos de Kubernetes

```bash
# Ejecutar comando dentro de un pod
kubectl exec -it <nombre-pod> -n k8s-ns-by-tf -- /bin/bash

# Describir un recurso
kubectl describe pod <nombre-pod> -n k8s-ns-by-tf

# Eliminar un pod
kubectl delete pod <nombre-pod> -n k8s-ns-by-tf

# Ver eventos del clúster
kubectl get events -n k8s-ns-by-tf
```

### Comandos de Minikube

```bash
# Ver IP del clúster
minikube ip

# Pausar el clúster
minikube pause

# Reanudar el clúster
minikube unpause

# Detener Minikube
minikube stop

# Eliminar el clúster
minikube delete

# Ver addons disponibles
minikube addons list

# Habilitar metrics-server
minikube addons enable metrics-server
```

---

## Conclusiones

Este proyecto demuestra que:

 **Kubernetes** es una herramienta poderosa para gestionar aplicaciones en contenedores de forma automática, eficiente y escalable.

 **Minikube** facilita la instalación y prueba de Kubernetes en un entorno local, resultando ideal para aprendizaje y desarrollo.

 **Terraform** permite automatizar el despliegue de infraestructura mediante código, garantizando reproducibilidad y consistencia.

 **Docker sobre Minikube** permite ejecutar contenedores de manera rápida sin necesidad de infraestructura externa, optimizando tiempo y recursos.

 **Implementar esta infraestructura en Windows** demuestra que es posible simular entornos profesionales desde una máquina personal.

 Este proyecto permite comprender conceptos clave como **clústeres, nodos, pods y orquestación**, aplicándolos de forma práctica.

### Aprendizajes Clave

- Dominio de Infraestructura como Código (IaC) con Terraform
- Comprensión profunda de la orquestación de contenedores con Kubernetes
- Habilidades en control de versiones con Git y GitHub
- Capacidad de desplegar aplicaciones completas (frontend, backend, base de datos)
- Experiencia práctica en DevOps y automatización

---

##  Bibliografía

- [Git Official Documentation](https://git-scm.com/downloads/win)
- [Terraform Official Documentation](https://developer.hashicorp.com/terraform)
- [Minikube Official Documentation](https://minikube.sigs.k8s.io/docs/start/)
- [Tutorial: Infraestructura como Código con Terraform](https://galvarado.com.mx/post/tutorial-infraestructura-como-código-con-terraform/)
- [Terraform Kubernetes Provider Examples](https://github.com/chefgs/terraform_repo/blob/main/kubernetes/providers.tf)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/home/)

---

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

---

## Autor

**Iván Loor**  
2º ASIR - Trabajo de Fin de Grado

---

## Agradecimientos

Gracias a la comunidad de código abierto por proporcionar herramientas tan potentes y accesibles para el aprendizaje y desarrollo de infraestructura moderna.

---

## Contacto

Si tienes preguntas o sugerencias sobre este proyecto, no dudes en abrir un **Issue** en GitHub o contactarme directamente.

---

<div align="center">
  <strong>⭐ Si te ha gustado este proyecto, dale una estrella ⭐</strong>
  <br><br>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white" />
</div>