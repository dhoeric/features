#!/usr/bin/env bash

# This test can be run with the following command (from the root of this repo)
#    devcontainer features test \
#               --features google-cloud-cli \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "gcloud version" gcloud --version
check "gke-gcloud-auth-plugin is not installed" [ "$(grep "gke-gcloud-auth-plugin" <(gcloud --version))" = "" ]
check "pubsub-emulator is not installed" [ "$(grep "pubsub-emulator" <(gcloud --version))" = "" ]

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults