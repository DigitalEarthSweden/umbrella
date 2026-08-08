#!/bin/bash -e

error() {
  echo -e "$*" 1>&2
  exit 1
}

[ -n "$ALL_PATTERN" ] || error "No ALL_PATTERN defined"
[ -n "$PACKAGES_PATTERN" ] || error "No PACKAGES_PATTERN defined"
[ -n "$PACKAGES_DIRECTORY" ] || error "No PACKAGES_DIRECTORY defined"

[[ $PACKAGES_PATTERN =~ $PACKAGES_DIRECTORY ]] ||
  error "Incompatible PACKAGES_* values ($PACKAGES_PATTERN =~ $PACKAGES_DIRECTORY)"

[ -n "$GITHUB_EVENT_NAME" ] || error "No GITHUB_EVENT_NAME defined"

[ -n "$ORIGIN_NAME" ] || export ORIGIN_NAME=origin

if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
  [ -n "$GITHUB_PR_BASE_REF" ] || error "No GITHUB_PR_BASE_REF defined"
  git fetch -q origin "$GITHUB_PR_BASE_REF"
  all_files=$(git diff --name-only "$ORIGIN_NAME/$GITHUB_PR_BASE_REF" HEAD)
elif [ "$GITHUB_EVENT_NAME" = "push" ]; then
  [ -n "$GITHUB_EVENT_AFTER" ] || error "No GITHUB_EVENT_AFTER defined"
  [ -n "$GITHUB_EVENT_BEFORE" ] || error "No GITHUB_EVENT_BEFORE defined"
  all_files=$(git diff --name-only "$GITHUB_EVENT_BEFORE" "$GITHUB_EVENT_AFTER")
fi
declare -a PKGS
# Rebuild everything on CI changes and schedule/manual trigger.
if [[ $all_files =~ $ALL_PATTERN ]] || [ "$GITHUB_EVENT_NAME" = "schedule" ] || [ "$GITHUB_EVENT_NAME" = "workflow_dispatch" ]; then
  for d in "$PACKAGES_DIRECTORY"/*/; do
    if [ -n "$SED_REPLACEMENTS" ]; then
      d=$(echo "$d" | sed $SED_REPLACEMENTS)
    fi
    if [[ ! " ${PKGS[*]} " =~ " ${d} " ]]; then
      PKGS+=("$d")
    fi
  done
elif [[ $all_files =~ $PACKAGES_PATTERN ]]; then
  for file in $all_files; do
    if [ -n "$CFG_PATTERN" ] && [[ $file =~ $CFG_PATTERN ]]; then
      PKGS1=$(echo "$file" | awk -F"/$PACKAGES_DIRECTORY/" '{print $2}' | awk -F/ '{print $1}')
    elif [[ $file =~ $PACKAGES_PATTERN ]]; then
      PKGS1=$(echo "$file" | awk -F"$PACKAGES_DIRECTORY/" '{print $2}' | awk -F/ '{print $1}')
    else
      continue
    fi
    if [ -n "$SED_REPLACEMENTS" ]; then
      PKGS1=$(echo "$PKGS1" | sed $SED_REPLACEMENTS)
    fi
    if [[ ! " ${PKGS[*]} " =~ " $PACKAGES_DIRECTORY/${PKGS1} " ]]; then
      PKGS+=("$PACKAGES_DIRECTORY/$PKGS1")
    fi
  done
fi
tmp=""
for pkg in "${PKGS[@]}"; do
  if [ -n "$EXCLUDED_PATTERN" ] && [[ $pkg =~ $EXCLUDED_PATTERN ]]; then
    continue
  fi
  if [ -n "$INCLUDED_PATTERN" ] && [[ ! $pkg =~ $INCLUDED_PATTERN ]]; then
    continue
  fi
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
