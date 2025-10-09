variable "location" {
  description = "Cluster zone or region."
  type        = string
}

variable "addons" {
  description = "Addons enabled in the cluster (true means enabled)."
  type = object({
    horizontal_pod_autoscaling = optional(bool, true)
    http_load_balancing        = optional(bool, true)
    network_policy_config      = optional(bool, true)
    gcp_filestore_csi_driver_config = optional(object({
      enabled = optional(bool, false)
      tier    = optional(string, "standard")
    }), {})
    cloudrun_config                       = optional(bool, false)
    dns_cache_config                      = optional(bool, false)
    gce_persistent_disk_csi_driver_config = optional(bool, true)
  })
  default = {}
}

variable "enable_dataplane_v2" {
  description = "Enable Dataplane V2 on the cluster, will disable network_policy addons config"
  type        = bool
  default     = true
}

variable "authenticator_groups_config" {
  description = "RBAC security group for Google Groups for GKE, format is gke-security-groups@yourdomain.com."
  type        = string
  default     = "gke-security-groups@dapperlabs.com"
}

variable "default_max_pods_per_node" {
  description = "Maximum number of pods per node in this cluster."
  type        = number
  default     = 110
}

variable "description" {
  description = "Cluster description."
  type        = string
  default     = null
}

variable "labels" {
  description = "Cluster resource labels."
  type        = map(string)
  default     = null
}

variable "maintenance_start_time" {
  description = "Maintenance start time in RFC3339 format 'HH:MM', where HH is [00-23] and MM is [00-59] GMT."
  type        = string
  default     = "03:00"
}

variable "master_authorized_ranges" {
  description = "External Ip address ranges that can access the Kubernetes cluster master through HTTPS."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Cluster name."
  type        = string
}

variable "network" {
  description = "Name or self link of the VPC used for the cluster. Use the self link for Shared VPC."
  type        = string
}

variable "node_locations" {
  description = "Zones in which the cluster's nodes are located."
  type        = list(string)
  default     = []
}

variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the master nodes"
  type        = string
}

variable "project_id" {
  description = "Cluster project id."
  type        = string
}

variable "release_channel" {
  description = "Release channel for GKE upgrades."
  type        = string
  default     = null
}

variable "secondary_range_pods" {
  description = "Subnet secondary range name used for pods."
  type        = string
}

variable "secondary_range_services" {
  description = "Subnet secondary range name used for services."
  type        = string
}

variable "subnetwork" {
  description = "VPC subnetwork name or self link."
  type        = string
}

variable "vertical_pod_autoscaling" {
  description = "Enable the Vertical Pod Autoscaling feature."
  type        = bool
  default     = null
}

variable "workload_identity_profiles" {
  description = <<EOF
  Namespace-keyed map of GCP Service Account to create K8S Service Accounts for.
  EOF
  type = map(
    list(
      object(
        {
          email                           = string
          create_service_account_token    = optional(bool, false)
          automount_service_account_token = optional(bool, false)
        }
      )
    )
  )
  default = {}
}

variable "primary_cluster" {
  type        = bool
  description = "Set to false if this is used for a non-default region deployment. This is needed to we don't recreate the workloadIdentityUser IAM binding each time we create a new region."
  default     = false
}

variable "master_global_access_config" {
  description = "Enable master global access config."
  type        = bool
  default     = false
}
