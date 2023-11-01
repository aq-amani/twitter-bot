## About
A twitter bot that runs on GCP CloudFunctions. The bot randomly chooses a tweet from a list of tweets saved on google cloudstore.

The bot runs every 3 hours, but the period can be adjusted by adjusting the schedule of the `google_cloud_scheduler_job resource` in `terraform/cloudfunction.tf`.

## Initial preperations
- Fill in the csv file with tweets, and serial int IDs of tweets.
- run `populate_datastore.py` to read tweets and ids from the csv file and populate Google cloud datastore with it.
- create a bucket for the terraform remote state
```bash
export BUCKET_NAME=<BUCKET_NAME_HERE>
export REGION=<REGION_NAME_HERE>
gcloud storage buckets create gs://$BUCKET_NAME --default-storage-class STANDARD --location $REGION
```
- Configure the terraform `backend.conf` file with the name of the newly created bucket
```bash
echo "bucket = $BUCKET_NAME" > backend.conf
```
- fill in the necessary variables in terraform `values.tfvars` file

## Authenticate to GCP inorder to run terraform against it
Either authenticate as a user while allowing apps to use the credentials:
```
gcloud auth application-default login
```

OR use a service account that has the necessary permissions. After obtaining(generating) the json key from the service account, pass it to the google provider as follows:
```
provider "google" {
  credentials = file("./serviceaccount_key.json")
}
```
## Set up the peoject on GCP using terraform
- initialize terraform using the backend.conf file
```bash
cd terraform
terraform init -backend-config=backend.conf
```
- check the resources to be created using the tfvars file
```bash
terraform apply -var-file values.tfvars
```
- apply the changes to GCP using terraform with the tfvars file
```bash
terraform apply -var-file values.tfvars
```

## Notes
- Twitter doesn't allow a duplicate tweet within a 12hours window
- datastore not setup using terraform, rather data is populated in the initial setup above
- secrets are manually saved after creating the secret resources
 - secrets are used for the twitter API tokens and keys 
