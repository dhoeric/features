#!/bin/bash

# The 'test/_global' folder is a special test folder that is not tied to a single feature.
#
# This test file is executed against a running container constructed
# from the value of 'color_and_hello' in the tests/_global/scenarios.json file.
#
# The value of a scenarios element is any properties available in the 'devcontainer.json'.
# Scenarios are useful for testing specific options in a feature, or to test a combination of features.
#
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test --global-scenarios-only .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "gcloud version" gcloud --version
check "opa version" opa version
check "conftest version" conftest --version
check "tfsec version" tfsec --version
check "trivy version" trivy --version
check "act version" act --version
check "k9s version" k9s version
check "flyctl version" flyctl version
check "aztfy version" aztfy --version
check "terraformer version" terraformer --version
check "terraform-docs version" terraform-docs --version
check "k6 version" k6 version
check "hadolint version" hadolint --version
check "mizu version" mizu version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
