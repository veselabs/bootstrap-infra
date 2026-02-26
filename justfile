# List all recipes
default:
    @just --list

# Init the Terraform backend
terraform-init *ARGS:
    terraform init -backend-config=<(envsubst -i backend.config) {{ ARGS }}

# Check the Terraform docs
[group('docs')]
check-docs:
    #!/usr/bin/env bash
    set -euxo pipefail
    recursive=$([[ -e modules ]] && echo true || echo false)
    terraform-docs markdown table . \
        --recursive="${recursive}" \
        --output-file=README.md \
        --output-check

# Generate the Terraform docs
[group('docs')]
generate-docs:
    #!/usr/bin/env bash
    set -euxo pipefail
    recursive=$([[ -e modules ]] && echo true || echo false)
    terraform-docs markdown table . \
        --recursive="${recursive}" \
        --output-file=README.md

# Lock the Terraform providers
lock-providers:
    terraform providers lock \
        -platform=darwin_amd64 \
        -platform=darwin_arm64 \
        -platform=linux_amd64 \
        -platform=linux_arm64
