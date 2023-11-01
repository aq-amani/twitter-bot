# GCP related variables
variable "project_id" {
  type    = string
}

variable "region" {
  type    = string
}

# Roles to assign to the service account
variable "sa_roles" {
  type = set(string)

  default = [
    # datastore user mainly for the twitterbot CF
    "roles/datastore.user",
    # CF invoker is mainly for the scheduled job
    "roles/cloudfunctions.invoker"
  ]
}

# Secret entries to create in Secrets Manager
# Secret values need to be input to these entries after creation
variable "secrets" {
  type = set(string)

  default = [
    "tw_access_token",
    "tw_access_token_secret",
    "tw_api_key",
    "tw_api_key_secret",
  ]
}

# twitterbot CF env variable
variable "max_id" {
  type    = number
}

# cron expression for the scheduled job
# once every 3 hours by default
variable "schedule" {
  type    = string
  default = "0 */3 * * *"
}
