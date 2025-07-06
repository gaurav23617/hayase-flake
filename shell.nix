{ pkgs }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jq
    curl
    nix-prefetch
    # Development tools
    nixpkgs-fmt
    nix-tree
    # For validation script
    bash
  ];

  shellHook = ''
    echo "Hayase development environment loaded"
    echo "Available commands:"
    echo "  - nix build: Build the package"
    echo "  - nix flake check: Run all checks"
    echo "  - nix develop: Enter development shell"
    echo "  - ./scripts/validate-version.sh: Validate version.json"
    echo "  - ./scripts/validate-version.sh --all: Full validation"

    # Make validation script executable
    if [ -f scripts/validate-version.sh ]; then
      chmod +x scripts/validate-version.sh
    fi
  '';
}
