#!/usr/bin/env bash

set -e

# Clean up
rm -rf /var/lib/apt/lists/*

GCLOUD_VERSION=${VERSION:-"latest"}
INSTALL_GKEGCLOUDAUTH_PLUGIN="${INSTALL_GKEGCLOUDAUTH_PLUGIN:-"false"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

apt_get_update()
{
    echo "Running apt-get update..."
    apt-get update -y
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt_get_update
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive

# Soft version matching that resolves a version for a given package in the *current apt-cache*
# Return value is stored in first argument (the unprocessed version)
apt_cache_version_soft_match() {

    # Version
    local variable_name="$1"
    local requested_version=${!variable_name}
    # Package Name
    local package_name="$2"

    # Ensure we've exported useful variables
    . /etc/os-release
    local architecture="$(dpkg --print-architecture)"

    dot_escaped="${requested_version//./\\.}"
    dot_plus_escaped="${dot_escaped//+/\\+}"
    # Regex needs to handle debian package version number format: https://www.systutorials.com/docs/linux/man/5-deb-version/
    version_regex="^(.+:)?${dot_plus_escaped}([\\.\\+ ~:-]|$)"
    set +e # Don't exit if finding version fails - handle gracefully
        fuzzy_version="$(apt-cache madison ${package_name} | awk -F"|" '{print $2}' | sed -e 's/^[ \t]*//' | grep -E -m 1 "${version_regex}")"
    set -e
    if [ -z "${fuzzy_version}" ]; then
        echo "(!) No full or partial for package \"${package_name}\" match found in apt-cache for \"${requested_version}\" on OS ${ID} ${VERSION_CODENAME} (${architecture})."
        echo "Available versions:"
        apt-cache madison ${package_name} | awk -F"|" '{print $2}' | grep -oP '^(.+:)?\K.+'
        exit 1 # Fail entire script
    fi

    # Globally assign fuzzy_version to this value
    # Use this value as the return value of this function
    declare -g ${variable_name}="=${fuzzy_version}"
    echo "${variable_name} ${!variable_name}"
}

install_using_apt() {
    # Install dependencies
    check_packages apt-transport-https curl ca-certificates gnupg python3
    # Import key
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    apt_get_update

    if [ "${GCLOUD_VERSION}" = "latest" ]; then
        # Empty, meaning grab the "latest" in the apt repo
        GCLOUD_VERSION=""
    else
        # Sets GCLOUD_VERSION to our desired version, if match found.
        apt_cache_version_soft_match GCLOUD_VERSION "google-cloud-cli"
        if [ "$?" != 0 ]; then
            return 1
        fi
    fi

    if ! (apt-get install -yq google-cloud-cli${GCLOUD_VERSION}); then
        rm -f /etc/apt/sources.list.d/google-cloud-sdk.list
        return 1
    fi

    # Install gke-gcloud-auth-plugin if needed
    if [ "${INSTALL_GKEGCLOUDAUTH_PLUGIN}" = "true" ]; then
        echo "(*) Installing 'gke-gcloud-auth-plugin' plugin..."
        check_packages google-cloud-sdk-gke-gcloud-auth-plugin
    fi
}

echo "(*) Installing google-cloud CLI..."
. /etc/os-release

# Install
install_using_apt

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
