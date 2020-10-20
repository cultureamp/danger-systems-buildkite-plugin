#!/bin/bash
set -euo pipefail

js_build () {
  BUILDKITE_PLUGIN_DANGER_SYSTEMS_LANGUAGE_VERSION=${BUILDKITE_PLUGIN_DANGER_SYSTEMS_LANGUAGE_VERSION:-"12"}

  BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

  echo "--- :docker: Building danger-js image"
  docker build \
    -t cultureamp/danger-js \
    --build-arg NODE_IMAGE_VERSION="${BUILDKITE_PLUGIN_DANGER_SYSTEMS_LANGUAGE_VERSION}" \
    -f "$BASEDIR/Dockerfile.node" "$(pwd)"
}

js_run () {
  # Installation vars
  GITHUB_REGISTRY_TOKEN=${GITHUB_REGISTRY_TOKEN:-}
  # Run vars
  # Note this ENV var differs from the `DANGER_GITHUB_API_TOKEN` that danger
  # expects to be available for reasons of descriptiveness
  DANGER_SYSTEMS_GITHUB_TOKEN=${DANGER_SYSTEMS_GITHUB_TOKEN:-}
  BUILDKITE=${BUILDKITE:-}
  BUILDKITE_REPO=${BUILDKITE_REPO:-}
  BUILDKITE_PULL_REQUEST=${BUILDKITE_PULL_REQUEST:-}
  BUILDKITE_BUILD_URL=${BUILDKITE_BUILD_URL:-}

  BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

  echo "--- :docker: Running danger-js"
  docker run \
    -v "$(pwd)":/home/app \
    -v "$BASEDIR/bin":/build \
    -e GITHUB_REGISTRY_TOKEN="$GITHUB_REGISTRY_TOKEN" \
    -e DANGER_SYSTEMS_GITHUB_TOKEN="$DANGER_SYSTEMS_GITHUB_TOKEN" \
    -e BUILDKITE="$BUILDKITE" \
    -e BUILDKITE_REPO="$BUILDKITE_REPO" \
    -e BUILDKITE_PULL_REQUEST="$BUILDKITE_PULL_REQUEST" \
    -e BUILDKITE_BUILD_URL="$BUILDKITE_BUILD_URL" \
    cultureamp/danger-js \
    /bin/sh /build/docker_js_run
}
