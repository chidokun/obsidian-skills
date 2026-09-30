#!/usr/bin/env bash
# Bump the plugin version in every manifest at once.
#
# Usage: scripts/bump-version.sh <patch|minor|major|X.Y.Z>
#
# Claude Code decides whether to update an installed plugin by comparing this
# version, so bump it every time you publish a change to the skills.

set -euo pipefail

cd "$(dirname "$0")/.."

FILES=(
  .claude-plugin/plugin.json
  .claude-plugin/marketplace.json
  .cursor-plugin/plugin.json
)
SEMVER='^[0-9]+\.[0-9]+\.[0-9]+$'

die() { echo "error: $*" >&2; exit 1; }

[[ $# -eq 1 ]] || die "usage: $0 <patch|minor|major|X.Y.Z>"

# Read the current version from the first manifest, then require all of them to agree.
current=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "${FILES[0]}" | head -n 1)
[[ $current =~ $SEMVER ]] || die "cannot read a X.Y.Z version from ${FILES[0]}"

for f in "${FILES[@]}"; do
  [[ -f $f ]] || die "missing $f"
  found=$(grep -c "\"version\": *\"$current\"" "$f" || true)
  [[ $found -eq 1 ]] || die "$f does not contain exactly one version $current (found $found); fix it by hand first"
done

IFS=. read -r major minor patch <<<"$current"
case $1 in
  patch) new="$major.$minor.$((patch + 1))" ;;
  minor) new="$major.$((minor + 1)).0" ;;
  major) new="$((major + 1)).0.0" ;;
  *)
    [[ $1 =~ $SEMVER ]] || die "'$1' is not patch, minor, major or X.Y.Z"
    new=$1
    ;;
esac

[[ $new != "$current" ]] || die "new version equals current version ($current)"

for f in "${FILES[@]}"; do
  # Write to a temp file instead of `sed -i` because its syntax differs between macOS and Linux.
  sed "s/\"version\": *\"$current\"/\"version\": \"$new\"/" "$f" >"$f.tmp"
  mv "$f.tmp" "$f"
  echo "updated $f"
done

echo "$current -> $new"
