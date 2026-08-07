#!/bin/bash -e

error() {
  echo -e "$*" 1>&2
  exit 1
}

# Files/directories that trigger rebuild of everything.
ALL_PATTERN="\.github\/|\.dockerignore|common\/Makefile"
# Package changes, only rebuild the specific packages.
PACKAGES_PATTERN="packages\/"
if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
  git fetch origin "$GITHUB_PR_BASE_REF"
  all_files=$(git diff --name-only "origin/$GITHUB_PR_BASE_REF" HEAD)
elif [ "$GITHUB_EVENT_NAME" = "push" ]; then
  all_files=$(git diff --name-only "$GITHUB_EVENT_BEFORE" "$GITHUB_EVENT_AFTER")
fi
declare -a PKGS
# Rebuild everything on CI changes and schedule/manual trigger.
if [[ $all_files =~ $ALL_PATTERN ]] || [ "$GITHUB_EVENT_NAME" = "schedule" ] || [ "$GITHUB_EVENT_NAME" = "workflow_dispatch" ]; then
  for d in packages/*/; do
    PKGS+=("$d")
  done
elif [[ $all_files =~ $PACKAGES_PATTERN ]]; then
  CFG_PATTERN="\/packages\/"
  for file in $all_files; do
    if [[ $file =~ $CFG_PATTERN ]]; then
      PKGS1=$(echo "$file" | awk -F/packages/ '{print $2}' | awk -F/ '{print $1}')
    elif [[ $file =~ $PACKAGES_PATTERN ]]; then
      PKGS1=$(echo "$file" | awk -Fpackages/ '{print $2}' | awk -F/ '{print $1}')
    fi
    if [[ ! " ${PKGS[*]} " =~ " ${PKGS1} " ]]; then
      PKGS+=("$PKGS1")
    fi
  done
fi
tmp=""
for pkg in "${PKGS[@]}"; do
  BUILD_TIMEOUT=$(make --no-print-directory -C "$pkg" build-timeout)
  EXTRA_REPOSITORY=$(make --no-print-directory -C "$pkg" extra-build-repository)
  if [ "$tmp" != "" ]; then
    tmp+=","
  fi
  tmp+="{\"package\": \"$pkg\", \"build-timeout\": $BUILD_TIMEOUT, \"extra-repository\": \"$EXTRA_REPOSITORY\"}"
done
if [ "$tmp" = "" ]; then
  error "Internal error: no changes detected. Debug info (all_files): $all_files"
fi
echo "matrix={\"include\":[$tmp]}"
