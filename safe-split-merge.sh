#!/usr/bin/env bash
set -euo pipefail

# SplitMerge.sh — Split and merge large files with MD5 checks in Git Bash on Windows
#
# Usage:
#   ./SplitMerge.sh split <source_file> <chunk_size_MB> <output_dir>
#   ./SplitMerge.sh merge <input_dir>  <merged_file>
#

function split_file() {
  local source_file="$1"
  local chunk_mb="$2"
  local out_dir="$3"

  mkdir -p "$out_dir"
  echo "🔪 Splitting '$source_file' into ${chunk_mb}MB parts in '$out_dir'..."
  split -b "${chunk_mb}m" -d -a 4 "$source_file" "$out_dir/part_"
  echo "📝 Generating MD5 checksum..."
  md5sum "$source_file" > "$out_dir/original.md5"
  echo "✅ Split complete; checksum saved to '$out_dir/original.md5'."
}

function merge_file() {
  local in_dir="$1"
  local out_file="$2"

  echo "🔗 Merging parts from '$in_dir' into '$out_file'..."
  cat $(ls "$in_dir"/part_* | sort) > "$out_file"
  echo "📝 Verifying MD5 checksum..."
  original_md5=$(cut -d ' ' -f 1 "$in_dir/original.md5")
  merged_md5=$(md5sum "$out_file" | cut -d ' ' -f 1)

  if [[ "$original_md5" == "$merged_md5" ]]; then
    echo "✅ Checksum OK — file integrity confirmed."
  else
    echo "❌ Checksum mismatch! The merged file may be corrupted." >&2
    exit 1
  fi
}

if [[ "${1:-}" == "split" ]]; then
  if [[ $# -ne 4 ]]; then
    echo "Usage: $0 split <source_file> <chunk_size_MB> <output_dir>"
    exit 1
  fi
  split_file "$2" "$3" "$4"

elif [[ "${1:-}" == "merge" ]]; then
  if [[ $# -ne 3 ]]; then
    echo "Usage: $0 merge <input_dir> <merged_file>"
    exit 1
  fi
  merge_file "$2" "$3"

else
  echo "Invalid mode. Use 'split' or 'merge'."
  echo "  $0 split <source_file> <chunk_size_MB> <output_dir>"
  echo "  $0 merge <input_dir> <merged_file>"
  exit 1
fi
