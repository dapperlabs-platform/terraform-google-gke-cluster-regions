output "endpoint" {
  description = "Cluster endpoint."
  value       = google_container_cluster.cluster.endpoint
}

output "location" {
  description = "Cluster location."
  value       = google_container_cluster.cluster.location
}

output "name" {
  description = "Cluster name."
  value       = google_container_cluster.cluster.name
}

output "ca_certificate" {
  description = "Public certificate of the cluster (base64-encoded)."
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}
