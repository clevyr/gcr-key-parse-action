#!/usr/bin/env bash

gcloud auth activate-service-account --key-file - <<< $GCLOUD_KEY_FILE

# Get variables from gcloud
PROJECT_ID=$(gcloud projects list --format json | jq '.[]["projectId"]' | xargs)
# Set the project for the rest of the variable after it has been obtained
gcloud config set project $PROJECT_ID
CLUSTER=$(gcloud container clusters list --format json | jq '.[]["name"]' | xargs)
REGION=$(gcloud container clusters list --format json | jq '.[]["zone"]' | xargs)
DOCKER_PASS=$(gcloud auth print-access-token)

# Set all outputs
printf "::set-output name=gcloud_projectId::%s\n" "$PROJECT_ID"
printf "::set-output name=gcloud_cluster::%s\n" "$CLUSTER"
printf "::set-output name=gcloud_region::%s\n" "$REGION"
printf "::set-output name=docker_repo::%s\n" "us.gcr.io/$PROJECT_ID"
printf "::set-output name=docker_username::%s\n" "oauth2accesstoken"
printf "::set-output name=docker_password::%s\n" "$DOCKER_PASS"
