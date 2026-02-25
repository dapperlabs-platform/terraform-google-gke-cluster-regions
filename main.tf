resource "google_container_cluster" "cluster" {
  # general config
  project            = var.project_id
  name               = var.name
  description        = var.description
  location           = var.location
  resource_labels    = var.labels
  datapath_provider  = var.enable_dataplane_v2 ? "ADVANCED_DATAPATH" : "DATAPATH_PROVIDER_UNSPECIFIED"
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  # node config
  node_locations           = length(var.node_locations) == 0 ? null : var.node_locations
  remove_default_node_pool = true
  initial_node_count       = 1

  # TODO: maybe delete?
  default_max_pods_per_node = var.default_max_pods_per_node

  # network config
  network                  = var.network
  subnetwork               = var.subnetwork
  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting

  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_range_pods
    services_secondary_range_name = var.secondary_range_services
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    master_global_access_config {
      enabled = var.master_global_access_config
    }
  }
  # Terraform specific config
  deletion_protection = var.primary_cluster

  # Auth config
  authenticator_groups_config {
    security_group = var.authenticator_groups_config
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }


  # Use CloudDNS for routing (Probably sohuld be handled at the network level')
  # Docs: https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-dns#dns-scopes
  # dns_config {
  #   cluster_dns                   = "CLOUD_DNS"
  #   cluster_dns_scope             = "CLUSTER_SCOPE"
  #   additive_vpc_scope_dns_domain = "${var.location}.${var.project_id}"
  # }

  addons_config {
    dns_cache_config {
      enabled = var.addons.dns_cache_config
    }
    http_load_balancing {
      disabled = !var.addons.http_load_balancing
    }
    horizontal_pod_autoscaling {
      disabled = !var.addons.horizontal_pod_autoscaling
    }
    network_policy_config {
      disabled = !var.addons.network_policy_config
    }
    cloudrun_config {
      disabled = !var.addons.cloudrun_config
    }
    gce_persistent_disk_csi_driver_config {
      enabled = var.addons.gce_persistent_disk_csi_driver_config
    }
    gcp_filestore_csi_driver_config {
      enabled = var.addons.gcp_filestore_csi_driver_config.enabled
    }
    gke_backup_agent_config {
      enabled = var.addons.gke_backup_agent_config
    }
    gcs_fuse_csi_driver_config {
      enabled = var.addons.gcs_fuse_csi_driver_config
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = (
      length(var.master_authorized_ranges) == 0
      ? []
      : [var.master_authorized_ranges]
    )
    iterator = ranges
    content {
      dynamic "cidr_blocks" {
        for_each = ranges.value
        iterator = range
        content {
          cidr_block   = range.value
          display_name = range.key
        }
      }
    }
  }

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [""] : []
    content {
      channel = var.release_channel
    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.vertical_pod_autoscaling == null ? [] : [""]
    content {
      enabled = var.vertical_pod_autoscaling
    }
  }
}
