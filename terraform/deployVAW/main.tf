# ==== WORKBENCH VPC =================================================================

resource "google_compute_network" "vpc_network" {
  project                 = "$PROJECT_ID"
  name                    = "$NETWORK_NAME"
  auto_create_subnetworks = true
  mtu                     = 1460
}

# ==== WORKBENCH INSTANCE ============================================================

resource "google_workbench_instance" "workbench" {
  name     = "$INSTANCE_NAME"
  location = "$INSTANCE_LOCATION"

  gce_setup {
    machine_type = "$INSTANCE_MACHINE_TYPE"
    accelerator_configs {
      type       = "NVIDIA_TESLA_T4"
      core_count = 1
    }
    vm_image {
      project = "cloud-notebooks-managed"
      family  = "workbench-instances"
    }
  }
}

# ==== WORKBENCH DOCUMENTATION =======================================================

# https://cloud.google.com/vertex-ai/docs/workbench/instances/create#terraform