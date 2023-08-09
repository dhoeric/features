#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

check "gcloud version 430.0.0 installed" grep "430.0.0" <(gcloud --version)

# Report result
reportResults