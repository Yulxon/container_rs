{
  description = "Rust dev environment with MUSL target";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      fenix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        toolchain = fenix.packages.${system}.complete.withComponents [
          "rustc"
          "cargo"
          "rust-src"
          "clippy"
          "rustfmt"
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          name = "rust-musl-dev";

          buildInputs = [
            toolchain
            pkgs.musl
            # pkgs.musl-tools
            pkgs.libseccomp
            pkgs.gcc
            pkgs.glibc
          ];

          shellHook = ''
            echo "🦀 Fenix Rust toolchain loaded"
            echo "MUSL target available!"
          '';
        };
      }
    );
}
