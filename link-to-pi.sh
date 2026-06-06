#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.pi/agent"
SELF="$(basename "${BASH_SOURCE[0]}")"

EXCLUDES=(.git "$SELF")

is_excluded() {
  local name="$1"
  for e in "${EXCLUDES[@]}"; do
    [ "$name" = "$e" ] && return 0
  done
  return 1
}

mkdir -p "$TARGET_DIR"

shopt -s dotglob nullglob
for src in "$REPO_DIR"/*; do
  name="$(basename "$src")"
  if is_excluded "$name"; then
    echo "skip: $name"
    continue
  fi

  dst="$TARGET_DIR/$name"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    backup="$dst.bak-$(date +%Y%m%d-%H%M%S)"
    echo "backing up existing $dst -> $backup"
    mv "$dst" "$backup"
  fi

  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
done
