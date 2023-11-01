terraform {
  required_version = ">= 1.6"
  backend "gcs" {
    prefix  = "terraform/twitter-bot-priv"
  }
}

provider "google" {
  # service account key (or remove this line if authenticated as a user)
  #credentials = file("./serviceaccount_key.json")
  project     = var.project_id
}

resource "google_storage_bucket" "bucket" {
  name          = "my-cloudfunction-sources"
  location      = var.region
  storage_class = "STANDARD"
}
