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
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
        hayase = pkgs.hayase;
      in
      {
        packages = {
          default = hayase;
          hayase = hayase;
        };

        devShells.default = import ./shell.nix { inherit pkgs; };

        # Add checks for testing
        checks = {
          build = hayase;

          # Add a simple version check
          version-check = pkgs.runCommand "hayase-version-check" { } ''
            echo "Checking version consistency..."
            expected_version=$(${pkgs.jq}/bin/jq -r '.version' ${./version.json})
            actual_version="${hayase.version}"

            if [ "$expected_version" != "$actual_version" ]; then
              echo "Version mismatch: expected $expected_version, got $actual_version"
              exit 1
            fi

            echo "Version check passed: $actual_version"
            touch $out
          '';

          # Add validation script check
          validation =
            pkgs.runCommand "hayase-validation"
              {
                buildInputs = with pkgs; [
                  bash
                  jq
                  curl
                ];
              }
              ''
                cp -r ${./.} ./source
                cd source
                chmod +x scripts/validate-version.sh
                ./scripts/validate-version.sh
                touch $out
              '';
        };
      }
    )
    // {
      # Add overlay for easier integration
      overlays.default = final: prev: {
        hayase = final.callPackage ./package.nix { };
      };
    };
}
