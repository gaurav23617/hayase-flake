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
        version = "6.3.9";

        # Only x86_64-linux is supported - there's only one Linux AppImage
        supportedSystems = [ "x86_64-linux" ];

        # Download URL and hash
        src = pkgs.fetchurl {
          url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-hayase-${version}-linux.AppImage";
          hash = "sha256-RlANC9NNzLTtFvOwz6UoCaW6Zr6K5IhihUABGoXhCv0="; # Updated by CI
        };

        hayase = pkgs.appimageTools.wrapType2 {
          pname = "hayase";
          inherit version src;

          extraPkgs =
            pkgs: with pkgs; [
              # Add any additional dependencies here
              gtk3
              gsettings-desktop-schemas
              # Additional libraries that might be needed
              libnotify
              libappindicator-gtk3
            ];

          meta = with pkgs.lib; {
            description = "Torrent streaming made simple. Watch anime torrents, real-time with no waiting for downloads";
            homepage = "https://github.com/ThaUnknown/miru";
            license = licenses.gpl3Plus;
            platforms = supportedSystems;
            maintainers = [ maintainers.gaurav23617 ];
            mainProgram = "hayase";
          };
        };

      in
      if builtins.elem system supportedSystems then
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
      else
        {
          # For unsupported systems, provide empty packages
          packages = { };
          apps = { };
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
