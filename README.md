# bootstrap-infra

This Terraform configuration bootstraps the infrastructure required to store
Terraform state files.

## Getting started

### Prerequisites

Nix is fundamental to use this repository. Please install Nix by following the
[instructions](https://nixos.org/download).

### Installation

If you're using `direnv`, grant it permission to load the `.envrc` file and
enter the development environment automatically when changing to the project's
directory:

```sh
direnv allow
```

Otherwise, enter the development environment manually:

```sh
nix develop --impure
```

## Usage

The development environment has variables set to 1Password secret references.

To load the secrets in a temporary shell:

```sh
op run --no-masking $SHELL
```

To run an ad-hoc command with the secrets loaded:

```sh
op run --no-masking <command>...
```

Typically, you'd want to initialize the Terraform configuration and then apply
it:

```sh
terraform init
terraform apply
```

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket_terraform_state"></a> [s3\_bucket\_terraform\_state](#module\_s3\_bucket\_terraform\_state) | terraform-aws-modules/s3-bucket/aws | ~> 5.7.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
