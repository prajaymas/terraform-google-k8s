# Get available zones for Google Cloud region
data "google_compute_zones" "available" {
  count   = var.enable_google ? 1 : 0
  project = var.gcp_project
  region  = var.gcp_region
  status  = "UP"
}

# Get latest version available in the given zone
data "google_container_engine_versions" "current" {
  count    = var.enable_google ? 1 : 0
  project  = var.gcp_project
  location = data.google_compute_zones.available[count.index].names[0]
}

resource "google_container_cluster" "gke" {
  count              = var.enable_google ? 1 : 0
  name               = var.gke_name
  location           = var.enable_regional_cluster ? var.gcp_region : data.google_compute_zones.available[count.index].names[0]
  project            = var.gcp_project
  min_master_version = data.google_container_engine_versions.current[count.index].latest_master_version
  node_version       = data.google_container_engine_versions.current[count.index].latest_master_version

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  addons_config {
    http_load_balancing {
      disabled = false
    }
    //    horizontal_pod_autoscaling {
    //      disabled = true
    //    }
  }

  master_auth {
    username = var.username
    password = var.password

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # (Required for private cluster, optional otherwise) network (cidr) from which cluster is accessible
  master_authorized_networks_config {
    cidr_blocks {
      display_name = "gke-admin"
      cidr_block   = "0.0.0.0/0"
    }
  }
}

resource "google_container_node_pool" "nodepool" {
  count      = var.enable_google ? 1 : 0
  project    = var.gcp_project
  name       = var.gke_pool_name
  location   = var.enable_regional_cluster ? var.gcp_region : data.google_compute_zones.available[count.index].names[0]
  cluster    = google_container_cluster.gke[count.index].name
  node_count = var.gke_nodes
  version    = data.google_container_engine_versions.current[count.index].latest_master_version

  node_config {
    preemptible     = var.gke_preemptible
    machine_type    = var.gke_node_type
    service_account = var.gke_serviceaccount

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = var.gke_oauth_scopes

    labels = {
      Project = "K8s"
    }

    tags = ["k8s"]
  }
}
