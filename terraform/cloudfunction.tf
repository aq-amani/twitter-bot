data "archive_file" "function_archive" {
  type        = "zip"
  source_dir  = "../source"
  output_path = "./function_package.zip"
}

resource "google_storage_bucket_object" "package_object" {
  name   = "packages/function_package.${data.archive_file.function_archive.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_archive.output_path
}

resource "google_cloudfunctions_function" "twitterbot_cf" {
  name                  = "twitterbot"
  description           = "my twitter bot"
  runtime               = "python311"
  region                = var.region
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.package_object.name
  trigger_http          = true
  available_memory_mb   = 128
  timeout               = 60
  entry_point           = "run"
  environment_variables = {
    max_id = var.max_id,
    project_id = var.project_id
  }
  service_account_email = "${google_service_account.twitterbot_service_account.email}"
}

resource "google_cloud_scheduler_job" "twitterbot_scheduler" {
  name             = "twitterbot-scheduler"
  description      = "scheduler for twitter bot"
  region           = var.region
  # every 3 hours
  schedule         = var.schedule
  time_zone        = "Asia/Tokyo"
  #attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri          = google_cloudfunctions_function.twitterbot_cf.https_trigger_url
    body        = base64encode("{\"message\": \"Hello from cloud scheduler\"}")
    headers = {
      "Content-Type" = "application/json"
    }

    oidc_token {
      service_account_email = google_service_account.twitterbot_service_account.email
    }

  }

}
