{
  description = "Nix flake for Hayase";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        hayase = pkgs.callPackage ./package.nix { };
      in
      {
        packages.default = hayase;
        devShells.default = import ./shell.nix { inherit pkgs; };
      }
    );
}
