#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github

set -euo pipefail

echo "🔍 Checking for Hayase updates..."

# Get versions
LATEST_TAG=$(curl -s https://api.github.com/repos/ThaUnknown/miru/releases/latest | jq -r .tag_name)
LATEST_VERSION=${LATEST_TAG#v}
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' package.nix)

echo "📋 Current version: $CURRENT_VERSION"
echo "📋 Latest version: $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "✅ Already up to date"
  exit 0
fi

echo "🔄 Update needed: $CURRENT_VERSION -> $LATEST_VERSION"

# Fetch new hash
echo "📦 Fetching source hash..."
NEW_HASH=$(nix-prefetch-github ThaUnknown miru --rev "v$LATEST_VERSION")

# Update package.nix
echo "🔧 Updating package.nix..."
sed -i "s/version = \".*\"/version = \"$LATEST_VERSION\"/" package.nix
sed -i "s/hash = \".*\"/hash = \"$NEW_HASH\"/" package.nix

# Update version.json if it exists
if [ -f version.json ]; then
  echo "🔧 Updating version.json..."
  jq --arg version "$LATEST_VERSION" \
    --arg hash "$NEW_HASH" \
    '.version = $version | .sha256 = $hash' \
    version.json >version.json.tmp && mv version.json.tmp version.json
fi

echo "✅ Files updated successfully!"
echo ""
echo "Next steps:"
echo "1. Run 'nix build' to test the build"
echo "2. If build fails due to pnpm hash, the workflow will fix it automatically"
echo "3. Commit the changes"
