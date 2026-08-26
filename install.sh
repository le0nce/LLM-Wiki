#!/usr/bin/env bash
set -euo pipefail

# Install LLM Wiki into a target project directory.
# Usage: ./install.sh [target-path]
# Defaults to current directory if no target specified.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-.}"
TARGET="$(cd "$TARGET" && pwd)"

# Handle CLAUDE.md
if [ -f "$TARGET/CLAUDE.md" ]; then
    if grep -q "LLM Wiki" "$TARGET/CLAUDE.md"; then
        echo "[ ] CLAUDE.md already contains LLM Wiki instructions. Skipping."
    else
        printf '\n\n' >> "$TARGET/CLAUDE.md"
        cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET/CLAUDE.md"
        echo "[+] Appended wiki instructions to existing CLAUDE.md"
    fi
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
    echo "[+] Created CLAUDE.md"
fi

# Create directory structure
for dir in sources wiki/_index wiki/sources wiki/entities wiki/concepts wiki/analyses; do
    mkdir -p "$TARGET/$dir"
    echo "[+] Created $dir/"
done

# Copy template files (don't overwrite existing)
templates=(
    "wiki/_index/index.md"
    "wiki/_index/log.md"
    "wiki/overview.md"
    "wiki/conventions.md"
)

for tmpl in "${templates[@]}"; do
    if [ ! -f "$TARGET/$tmpl" ]; then
        cp "$SCRIPT_DIR/$tmpl" "$TARGET/$tmpl"
        echo "[+] Created $tmpl"
    else
        echo "[ ] Skipped $tmpl (already exists)"
    fi
done

echo ""
echo "LLM Wiki installed into: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Drop source documents into sources/"
echo "  2. Open Claude Code and say: /wiki ingest"
echo "  3. Query with: /wiki query <your question>"
