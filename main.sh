#!/usr/bin/env bash

set -euo pipefail

# Login to the gcloud cli
gcloud auth activate-service-account --key-file - <<< $GCLOUD_KEY_FILE

# Get variables from gcloud
PROJECT_ID="$(jq -r .project_id <<< $GCLOUD_KEY_FILE)"
CLUSTER="$(gcloud container --project $PROJECT_ID clusters list --format json | jq '.[]["name"]' | xargs)"
REGION="$(gcloud container --project $PROJECT_ID clusters list --format json | jq '.[]["zone"]' | xargs)"
DOCKER_PASS="$(gcloud auth print-access-token)"

# Set all outputs
printf "::set-output name=gcloud_projectId::%s\n" "$PROJECT_ID"
printf "::set-output name=gcloud_cluster::%s\n" "$CLUSTER"
printf "::set-output name=gcloud_region::%s\n" "$REGION"
printf "::set-output name=docker_repo::%s\n" "us.gcr.io/$PROJECT_ID"
printf "::set-output name=docker_username::%s\n" "oauth2accesstoken"
printf "::set-output name=docker_password::%s\n" "$DOCKER_PASS"
