{
  description = "bootstrap-infra";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts/main";
    treefmt-nix.url = "github:numtide/treefmt-nix/main";
    devenv.url = "github:cachix/devenv/v1.9";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];

      perSystem = {
        pkgs,
        self',
        system,
        ...
      }: let
        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            prettier.enable = true;
            terraform.enable = true;
            terraform.package = pkgs.terraform;
          };
        };
      in {
        devShells.default = inputs.devenv.lib.mkShell {
          inherit inputs pkgs;

          modules = [
            {
              env = {
                AWS_ACCESS_KEY_ID = "op://veselabs/aws root access key/username";
                AWS_SECRET_ACCESS_KEY = "op://veselabs/aws root access key/credential";
              };

              languages = {
                nix.enable = true;
                terraform.enable = true;
              };

              packages =
                [self'.formatter]
                ++ builtins.attrValues {
                  inherit
                    (pkgs)
                    awscli2
                    just
                    terraform-docs
                    ;
                };

              git-hooks.hooks = {
                deadnix.enable = true;
                end-of-file-fixer.enable = true;
                statix.enable = true;
                terraform-docs = {
                  enable = true;
                  entry = "just check-docs";
                  files = "\\.tf$";
                  pass_filenames = false;
                };
                tflint.enable = true;
                treefmt.enable = true;
                treefmt.package = self'.formatter;
                trim-trailing-whitespace.enable = true;
                yamllint.enable = true;
              };
            }
          ];
        };

        packages = {
          devenv-test = self'.devShells.default.config.test;
          devenv-up = self'.devShells.default.config.procfileScript;
        };

        formatter = treefmtEval.config.build.wrapper;
        checks.formatting = treefmtEval.config.build.check self;

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    });
}
