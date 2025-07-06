#!/usr/bin/env bash
set -euo pipefail

VERSION_FILE="version.json"
if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: version.json not found"
  exit 1
fi

VERSION=$(jq -r '.version' "$VERSION_FILE")
SHA256=$(jq -r '.sha256' "$VERSION_FILE")

if [ -z "$VERSION" ] || [ "$VERSION" = "null" ]; then
  echo "Error: Invalid version in version.json"
  exit 1
fi

if [ -z "$SHA256" ] || [ "$SHA256" = "null" ]; then
  echo "Error: Invalid SHA256 in version.json"
  exit 1
fi

echo "Version validation passed: $VERSION"
