#!/bin/bash
#
# This script manages aptly publishes by listing and optionally dropping them.
# 
# It supports a dry-run mode to show what would be dropped without actually performing the deletion.
#
# Usage:
#   ./aptlypublishlist-drop.sh --dry-run   Show what would be dropped without deleting anything.
#   ./aptlypublishlist-drop.sh             Actually run script.
#
# To properly run this script, give it execute permissions and run it from the shell:
#   chmod +x aptlypublishlist-drop.sh
#
# The dry-run option is useful for verifying what changes the script will make before applying them.
#
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [--dry-run]

Options:
  --dry-run   Show what would be dropped, but don't actually drop them.
  -h, --help  Show this help.
EOF
  exit 0
}

DRYRUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRYRUN=true ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
  shift
done

# Collect publishes (prefix + distribution)
publishes=$(aptly publish list | sed -n 's/^[[:space:]]*\* \([^/]\+\)\/\([^ ]\+\).*/\1 \2/p')

if [[ -z "$publishes" ]]; then
  echo "No publishes found."
  exit 0
fi

# Process each publish
while read -r prefix dist; do
  if $DRYRUN; then
    echo "[DRY-RUN] Would drop publish: distribution='$dist', prefix='$prefix'"
  else
    echo "Dropping publish: distribution='$dist', prefix='$prefix'"
    aptly publish drop "$dist" "$prefix"
  fi
done <<< "$publishes"

if $DRYRUN; then
  echo "Dry run finished – nothing was deleted."
else
  echo "All publishes dropped."
fi
