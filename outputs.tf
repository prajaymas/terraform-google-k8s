
output "latest_k8s_master_version" {
  value = data.google_container_engine_versions.current.*.latest_master_version
}
