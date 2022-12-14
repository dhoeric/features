# Dev Container Features

## Contents

This repository contains following features:
- [google-cloud-cli](./src/google-cloud-cli/README.md): Install Google Cloud CLI tools
- [opa](./src/opa/README.md): Install Open Policy Agent (opa)
- [conftest](./src/conftest/README.md): Install conftest
- [tfsec](./src/tfsec/README.md): Install tfsec
- [trivy](./src/trivy/README.md): Install trivy
- [act](./src/act/README.md): Install act
- [k9s](./src/k9s/README.md): Install k9s
- [flyctl](./src/flyctl/README.md): Install flyctl
- [aztfy](./src/aztfy/README.md): Install aztfy
- [terraformer](./src/terraformer/README.md): Install terraformer
- [terraform-docs](./src/terraform-docs/README.md): Install terraform-docs
- [k6](./src/k6/README.md): Install k6
- [hadolint](./src/hadolint/README.md): Install hadolint
- [mizu](./src/mizu/README.md): Install mizu
- [oras](./src/oras/README.md): Install oras
- [stern](./src/stern/README.md): Install stern

## Usage

To use the features from this repository, add the desired features to devcontainer.json.

This example use google-cloud-cli feature on devcontainer.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/dhoeric/features/google-cloud-cli:1": {
            "version": "latest"
        }
    }
}
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder.  Each feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```
├── src
│   ├── hello
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
│   ├── color
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time.  Implementing tools are also free to process attributes under the `customizations` property as desired.
