variable "enable_google" {
  description = "Enable / Disable Google Cloud k8s (e.g. `true`)"
  type        = bool
  default     = true
}

variable "enable_regional_cluster" {
  description = "Create regional GKE cluster instead of zonal"
  type        = bool
  default     = false
}

variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region (e.g. `asia-south1` => Mumbai)"
  type        = string
  default     = "asia-south1"
}

variable "gke_name" {
  description = "GKE cluster name (e.g. `k8s`)"
  type        = string
  default     = "kubernetes"
}

variable "username" {
  description = "Username for accessing the Kubernetes master"
  type        = string
  default     = "kubeadmin"
}

variable "password" {
  description = "Password for accessing the Kubernetes master"
  type        = string
  default     = "kubepasswd@12345"
}

variable "gke_pool_name" {
  description = "GKE node pool name (e.g. `k8snodepool`)"
  type        = string
  default     = "kubernetesnodepool"
}

variable "gke_nodes" {
  description = "GKE Kubernetes worker nodes (e.g. `2`)"
  type        = number
  default     = 2
}

variable "gke_preemptible" {
  description = "Use GKE preemptible nodes (e.g. `false`)"
  type        = bool
  default     = false
}

variable "gke_node_type" {
  description = "GKE node instance type (e.g. `n1-standard-2` => 1vCPU, 7.5 GB RAM)"
  type        = string
  default     = "n1-standard-2"
}

variable "gke_serviceaccount" {
  description = "GCP service account for GKE (e.g. `default`)"
  type        = string
  default     = "default"
}

variable "gke_oauth_scopes" {
  description = "GCP OAuth scopes for GKE (https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes)"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring"
  ]
}