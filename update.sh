#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github

set -euo pipefail

# Get the latest version from GitHub API
LATEST_TAG=$(curl -s https://api.github.com/repos/ThaUnknown/miru/releases/latest | jq -r .tag_name)
LATEST_VERSION=${LATEST_TAG#v}

echo "Latest version: $LATEST_VERSION"

# Get current version from package.nix
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' package.nix)
echo "Current version: $CURRENT_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "Already up to date"
  exit 0
fi

# Fetch new hash
echo "Fetching new hash..."
NEW_HASH=$(nix-prefetch-github ThaUnknown miru --rev "v$LATEST_VERSION")

# Update package.nix
echo "Updating package.nix..."
sed -i "s/version = \".*\"/version = \"$LATEST_VERSION\"/" package.nix
sed -i "s/hash = \".*\"/hash = \"$NEW_HASH\"/" package.nix

# Update pnpm deps hash (this will fail first, but that's expected)
echo "Updating pnpm dependencies hash..."
echo "Note: You'll need to run 'nix build' to get the correct pnpm hash and update it manually"

echo "Update complete!"
echo "Don't forget to:"
echo "1. Run 'nix build' to get the correct pnpm hash"
echo "2. Update the pnpmDeps hash in package.nix"
echo "3. Test the build"
