# Create GSM secret with Cluster details -> used to register cluster in ArgoCD more easily
# The cluster ca certificate
resource "google_secret_manager_secret" "gke_cluster_ca" {
  secret_id = "gke-cluster-${google_container_cluster.cluster.name}-ca-b64" # The name of your secret
  project   = var.project_id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "gke_cluster_ca" {
  secret      = google_secret_manager_secret.gke_cluster_ca.id
  secret_data = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}

# The clusters public endpoint
resource "google_secret_manager_secret" "gke_cluster_endpoint" {
  secret_id = "gke-cluster-${google_container_cluster.cluster.name}-endpoint" # The name of your secret
  project   = var.project_id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "gke_cluster_endpoint" {
  secret      = google_secret_manager_secret.gke_cluster_endpoint.id
  secret_data = google_container_cluster.cluster.endpoint
}
