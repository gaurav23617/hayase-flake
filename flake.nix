{
  description = "Hayase - Stream anime torrents, real-time with no waiting for downloads";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hayase = pkgs.callPackage ./package.nix { };
      in
      {
        packages = {
          default = hayase;
          hayase = hayase;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            pnpm
            electron
            # Update tools
            curl
            jq
            nix-prefetch-github
          ];

          shellHook = ''
            echo "Hayase development environment"
            echo "Available commands:"
            echo "  nix build                 - Build the package"
            echo "  nix run                   - Run hayase"
            echo "  ./update.sh               - Update to latest version"
            echo "  pnpm install              - Install dependencies"
            echo "  pnpm dev                  - Start development server"
          '';
        };

        # Simple checks
        checks = {
          build = hayase;
        };
      }
    );
}
