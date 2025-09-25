{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          lib,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt
              pkgs.nodejs_22
            ];
          };
          packages.firefox-dev = pkgs.firefox-devedition.override {
            extraPolicies = {
              "3rdparty".Extensions."surfingkeys@brookhong.github.io" = {
                showAdvanced = true;
                snippets = ''
                  api.Hints.style(`
                   font-size: 16px;
                   border: none;
                   color: #f5e0dc;
                   background: none;
                   background-color: #181825;
                 `)
                '';
              };
            };
          };
        };
    };
}
