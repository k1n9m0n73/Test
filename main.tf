provider "google" {
  project     = "rising-capsule-231307"
  region      = "us-central1"
}

variable "project_id" {
  default = "rising-capsule-231307"
}

variable "region" {
  default = "us-central1"
}

resource "google_project_service" "vpcaccess-api" {
  project = var.project_id # Replace this with your project ID in quotes
  service = "vpcaccess.googleapis.com"
}

#SETUP THE VPC
resource "google_compute_network" "network" {
  project                 = var.project_id # Replace this with your project ID in quotes
  name                    = "service-vpc"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  project                  = var.project_id
  name                     = "service-vpc-subnet"
  ip_cidr_range            = "10.2.0.0/28"
  region                   = var.region
  network                  = google_compute_network.network.name
}

module "serverless-connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version    = "~> 7.0"
  project_id = var.project_id
  vpc_connectors = [{
    name        = "central-serverless"
    region      = "us-central1"
    subnet_name = google_compute_subnetwork.vpc_subnetwork.name
    machine_type  = "e2-micro"
    min_instances = 2
    max_instances = 4
    max_throughput = 400
 }]
  depends_on = [
    google_project_service.vpcaccess-api
  ]
}


# SETUP PRIVATE & PUBLIC CLOUD RUN SERVICES

# PRIVATE CLOUD RUN SERVICE
resource "google_cloud_run_v2_service" "private_service" {
  name     = "private-service-backend"
  location = var.region # Adjust the region as needed
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template{ 
    containers {
      image = "gcr.io/cloudrun/hello" #public image for your service
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
      ports {
        container_port=3000
      }
    } 
    
    scaling {
      # Limit scale up to prevent any cost blow outs!
      max_instance_count = 2
    }
  }
}

# PUBLIC  CLOUD RUN SERVICE
resource "google_cloud_run_v2_service" "public_service" {
  name     = "public-service-frontend"
  location = var.region # Adjust the region as needed
  ingress = "INGRESS_TRAFFIC_ALL"

  template{ 

    containers {
      image = "gcr.io/cloudrun/hello" #public image for your service
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
      ports {
        container_port=80
      }
    } 
    
    scaling {
      # Limit scale up to prevent any cost blow outs!
      max_instance_count = 2
    }

    vpc_access {
      # Use the VPC Connector
      connector = "projects/rising-capsule-231307/locations/us-central1/connectors/central-serverless"
      egress = "ALL_TRAFFIC"
    }
  }
}

#AUTHENTICATION OF THE SERVICES
resource "google_cloud_run_v2_service_iam_member" "private_noauth" {
  location = var.region
  name     = "private-service-backend"
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "public_noauth" {
  location = var.region
  name     = "public-service-frontend"
  role     = "roles/run.invoker"
  member   = "allUsers"
}
