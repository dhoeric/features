#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

check "pubsub-emulator is installed" grep "pubsub-emulator" <(gcloud --version)

# Report result
reportResults