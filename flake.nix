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
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      rustToolchain = pkgs.rust-bin.fromRustupToolchainFile "${self}/rust-toolchain.toml";
      devRustToolchain = rustToolchain.override {
        extensions = [ "rust-src" ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          devRustToolchain
          pkgs.cargo-nextest
          pkgs.just
          pkgs.rust-analyzer
          pkgs.tombi
          pkgs.wild
          pkgs.clang
        ];
      };
    };
}
