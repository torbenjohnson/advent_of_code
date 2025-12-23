{
  description = "Advent of Code solutions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      inherit (nixpkgs.lib) genAttrs;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = genAttrs systems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
            config.allowUnfree = true;
          };
          rustToolchain = pkgs.rust-bin.fromRustupToolchainFile "${self}/rust-toolchain.toml";
          devRustToolchain = rustToolchain.override {
            extensions = [ "rust-src" ];
          };
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              devRustToolchain
              pkgs.rust-analyzer
              pkgs.cargo-nextest
              pkgs.just
              pkgs.tombi
              pkgs.wild
              pkgs.clang
            ];
          };

          ci = pkgs.mkShell {
            nativeBuildInputs = [
              rustToolchain
              pkgs.cargo-nextest
              pkgs.just
              pkgs.tombi
              pkgs.wild
              pkgs.clang
            ];
          };
        }
      );
    };
}
