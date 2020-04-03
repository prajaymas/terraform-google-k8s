provider "google" {
  credentials = file("account.json")
  project     = var.gcp_project
  region      = var.gcp_region
}
