resource "google_secret_manager_secret" "twitter_secrets" {
  for_each = var.secrets
  secret_id     = each.value
  replication {
    auto {}
  }
}

