#!/bin/bash
# Intel Skills Installer for Claude Code
# https://github.com/dengwx11/intel-skills

set -e

SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Intel Skills Installer ==="
echo ""

# Check Claude Code is installed
if ! command -v claude &> /dev/null; then
  echo "⚠️  Claude Code (claude) not found in PATH."
  echo "   Install it first: https://claude.ai/code"
  exit 1
fi

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Install each skill
for skill in intel-daily intel-quantum intel-autolab; do
  if [ -d "$SCRIPT_DIR/$skill" ]; then
    cp -r "$SCRIPT_DIR/$skill" "$SKILLS_DIR/"
    echo "✅ Installed /$skill → $SKILLS_DIR/$skill/"
  else
    echo "⚠️  Skipping $skill (directory not found)"
  fi
done

echo ""
echo "=== Installation complete ==="
echo ""
echo "Next steps:"
echo "  1. Set up grok-bridge: https://github.com/dengwx11/grok-bridge"
echo "  2. Start the bridge:   python3 scripts/x_grok_bridge.py --port 19999"
echo "  3. Run a briefing:     /intel-daily  (in Claude Code)"
echo ""
