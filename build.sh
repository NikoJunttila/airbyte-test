#!/bin/bash

# Exit on any error
set -e

# Configuration - Update these variables for your project
GITHUB_USERNAME="nikojunttila"
REPO_NAME="airbyte-test"
IMAGE_NAME="airbyte-connector"
REGISTRY="ghcr.io"

# Get version from git tag or use 'latest'
VERSION=${1:-$(git describe --tags --abbrev=0 2>/dev/null || echo "latest")}

# Full image name
FULL_IMAGE_NAME="${REGISTRY}/${GITHUB_USERNAME}/${IMAGE_NAME}"

echo "🏗️  Building Docker image..."
echo "Repository: ${REPO_NAME}"
echo "Image: ${FULL_IMAGE_NAME}:${VERSION}"
echo "----------------------------------------"

# Build the Docker image
docker build \
    --tag "${FULL_IMAGE_NAME}:${VERSION}" \
    --tag "${FULL_IMAGE_NAME}:latest" \
    .

echo "✅ Build completed successfully!"

# Check if we're authenticated to GitHub Container Registry
echo "🔐 Checking GitHub Container Registry authentication..."
if ! docker info | grep -q "ghcr.io"; then
    echo "⚠️  Please authenticate with GitHub Container Registry first:"
    echo "   echo \$GITHUB_TOKEN | docker login ghcr.io -u ${GITHUB_USERNAME} --password-stdin"
    echo ""
    echo "Or create a Personal Access Token with 'write:packages' scope at:"
    echo "   https://github.com/settings/tokens"
    read -p "Press Enter when you're ready to continue, or Ctrl+C to exit..."
fi

# Push the image
echo "📤 Pushing image to GitHub Container Registry..."
docker push "${FULL_IMAGE_NAME}:${VERSION}"

if [ "${VERSION}" != "latest" ]; then
    docker push "${FULL_IMAGE_NAME}:latest"
fi

echo "🎉 Successfully pushed to GitHub Packages!"
echo "Image available at: ${FULL_IMAGE_NAME}:${VERSION}"
echo ""
echo "To pull this image:"
echo "   docker pull ${FULL_IMAGE_NAME}:${VERSION}"
