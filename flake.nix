{
  description = "Rust dev environment with direnv support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          name = "rust-dev-shell";

          buildInputs = [
	    pkgs.rustc # Provides rustc and cargo
            pkgs.rust-analyzer
            pkgs.clippy
            pkgs.rustfmt
          ];

          shellHook = ''
            echo "🦀 Rust dev environment is ready!"
          '';
        };
      });
}

