{
  description = "Hayase (Miru) - Torrent streaming made simple";

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

        # Version information (auto-updated by GitHub Actions)
        version = "5.5.10";

        # Platform-specific download URLs and hashes
        sources = {
          x86_64-linux = {
            url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-Hayase-${version}.AppImage";
            hash = "sha256-nLPqEI6u5NNQ/kPbXRWPG0pIwutKNK2J8JeTPN6wHlg="; # Updated by CI
          };
          aarch64-linux = {
            url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-arm64-Hayase-${version}.AppImage";
            hash = "sha256-V4Vo9fuQ0X7Q6CBM7Akh3+MrgQOBgCuC41khFatYWi4="; # Updated by CI
          };
        };

        hayase = pkgs.appimageTools.wrapType2 {
          pname = "hayase";
          inherit version;

          src = pkgs.fetchurl sources.${system};

          extraPkgs =
            pkgs: with pkgs; [
              # Add any additional dependencies here
              gtk3
              gsettings-desktop-schemas
            ];

          meta = with pkgs.lib; {
            description = "Torrent streaming made simple. Watch anime torrents, real-time with no waiting for downloads";
            homepage = "https://github.com/ThaUnknown/miru";
            license = licenses.gpl3Plus;
            platforms = [
              "x86_64-linux"
              "aarch64-linux"
            ];
            maintainers = [ gaurav23617 ];
            mainProgram = "hayase";
          };
        };

      in
      {
        packages = {
          default = hayase;
          hayase = hayase;
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = hayase;
            name = "hayase";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix-update
            jq
            curl
          ];
        };
      }
    );
}
