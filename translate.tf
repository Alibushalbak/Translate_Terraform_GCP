######################################GCP_PROJECT##################################################
terraform {    
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {    
project = "devops102-analiza"
}


resource "google_project_service" "enaple1" {
  project = "devops102-analiza"
  service = "translate.googleapis.com"

  
  disable_dependent_services = true
}



resource "google_project_service" "enaple2" {
  project = "devops102-analiza"
  service = "artifactregistry.googleapis.com"

  
  disable_dependent_services = true
}

resource "google_project_service" "enaple3" {
  project = "devops102-analiza"
  service = "run.googleapis.com"

  
  disable_dependent_services = true
}



resource "google_cloud_run_service" "default" {
  name     = "ali-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/devops102-analiza/ali-translate"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}