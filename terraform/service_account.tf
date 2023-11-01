# This service account is used for both the CloudFunction and the scheduled task
resource "google_service_account" "twitterbot_service_account" {
  account_id   = "sa-twitter-bot"
  display_name = "Service Account for the twitter bot cloudfunction"
}


## This gives secretaccessor towards all secrets which is not good
#resource "google_project_iam_member" "secret_access" {
#  project = "kinetic-genre-402513"
#  role    = "roles/secretmanager.secretAccessor"
#  member  = "serviceAccount:${google_service_account.test_service_account.email}"
#  depends_on = [google_secret_manager_secret.my_secret]
#}

## This gives secretaccessor towards a specific secret. Better security-wise
resource "google_secret_manager_secret_iam_member" "secret_permissions" {
  for_each = var.secrets
  project = "kinetic-genre-402513"
  secret_id = each.value
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.twitterbot_service_account.email}"
  depends_on = [google_secret_manager_secret.twitter_secrets]
}


# datastore and cloudfunctions permissions
resource "google_project_iam_member" "permissions_for_service_account" {
  for_each = var.sa_roles
  project = "kinetic-genre-402513"
  role    = each.value
  member  = "serviceAccount:${google_service_account.twitterbot_service_account.email}"
}
