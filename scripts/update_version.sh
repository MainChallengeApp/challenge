#!/bin/bash

# Script to increment the version in a YAML file with semantic versioning

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <yaml_file> <version_component>"
    exit 1
fi

YAML_FILE="../pubspec.yaml"
VERSION_COMPONENT=$1

# Escape special characters in the key path for sed
ESCAPED_KEY_PATH="version"

# Get the current version from the YAML file
CURRENT_VERSION=$(sed -n -E "s/($ESCAPED_KEY_PATH:[[:space:]]*['\"]?([^'\"]+)['\"]?)/\2/p" "$YAML_FILE")

if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Unable to extract current version from '$YAML_FILE'. Make sure the version field is properly formatted."
    exit 1
fi

# Split the current version into major, minor, and patch components
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR="${VERSION_PARTS[0]}"
MINOR="${VERSION_PARTS[1]}"
PATCH="${VERSION_PARTS[2]}"
IFS='+' read -ra PATCH_PARTS <<< "$PATCH"
PATCH="${PATCH_PARTS[0]}"
BUILD_NUMBER="${PATCH_PARTS[1]}"

# Increment the specified version component
case $VERSION_COMPONENT in
    "major")
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    "minor")
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    "patch")
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "Error: Unsupported version component. Use 'major', 'minor', or 'patch'."
        exit 1
        ;;
esac

# stash all changes
# Update the version in the YAML file using sed
sed -i '' -E "s/($ESCAPED_KEY_PATH:[[:space:]]*)[0-9]+\.[0-9]+\.[0-9]+/\1$MAJOR.$MINOR.$PATCH/" "$YAML_FILE"

git add $YAML_FILE
git commit -m "update: v$CURRENT_VERSION to v$MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"
git tag "v$MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"

echo "Version incremented to '$MAJOR.$MINOR.$PATCH' in '$YAML_FILE' and committed to git."
