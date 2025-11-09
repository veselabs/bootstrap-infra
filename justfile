# Lists all recipes
default:
    @just --list

# Checks if the Terraform docs need to be regenerated
[group('docs')]
check-docs:
    #!/usr/bin/env bash
    set -euxo pipefail
    recursive=$([[ -e modules ]] && echo true || echo false)
    terraform-docs markdown table . \
        --recursive="${recursive}" \
        --output-file=README.md \
        --output-check

# Generates Terraform docs
[group('docs')]
generate-docs:
    #!/usr/bin/env bash
    set -euxo pipefail
    recursive=$([[ -e modules ]] && echo true || echo false)
    terraform-docs markdown table . \
        --recursive="${recursive}" \
        --output-file=README.md

# Locks the Terraform providers
lock-providers:
    #!/usr/bin/env bash
    set -euxo pipefail
    terraform providers lock \
        -platform=darwin_amd64 \
        -platform=darwin_arm64 \
        -platform=linux_amd64 \
        -platform=linux_arm64
