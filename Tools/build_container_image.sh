#!/usr/bin/env bash
# Edgar Hernandez | 2026-08-29
# Build the sim containerfile
# 
# Script expects user to be using rootless-podman to build the image

set -e

IMAGE_NAME="ros-jazzy-gz-sim"
CONTAINERFILE="Containerfile"
CONTEXT_DIR="."
LOG_NAME="container_build_log_$(date -Iseconds).txt"

# some prereqs to make sure we get the right hash for this
# ensure that we are in a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "not inside of a git repository, aborting :)." >&2
    exit 1
fi

# require that the workspace is clean
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "git workspace must be clean to continue, aborting >:)." >&2
    git status --short
    exit 1
fi

# build a tag for the image
GIT_HASH="$(git rev-parse --short=12 HEAD)"
FULL_TAG="${IMAGE_NAME}:${GIT_HASH}"
LATEST_TAG="${IMAGE_NAME}:latest"

echo "building ${FULL_TAG}"
podman build \
    -t "${FULL_TAG}" \
    -f "${CONTAINERFILE}" \
    "${CONTEXT_DIR}" \
    | tee ${LOG_NAME}

echo "tagging image as ${LATEST_TAG} "
podman tag "${FULL_TAG}" "${LATEST_TAG}"

echo "build complete"