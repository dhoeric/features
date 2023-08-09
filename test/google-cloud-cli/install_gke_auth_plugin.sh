#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

check "gke-gcloud-auth-plugin is installed" grep "gke-gcloud-auth-plugin" <(gcloud --version)

# Report result
reportResults