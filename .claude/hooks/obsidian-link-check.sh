#!/usr/bin/env bash
# Obsidian unresolved link checker
# Fires PostToolUse on Write/Edit — warns if editing a vault file introduced new broken links.
#
# To install, add to ~/.claude/settings.json:
# "hooks": {
#   "PostToolUse": [
#     {
#       "matcher": "Write",
#       "hooks": [{ "type": "command", "command": "C:/Users/Nick/.claude/hooks/obsidian-link-check.sh" }]
#     },
#     {
#       "matcher": "Edit",
#       "hooks": [{ "type": "command", "command": "C:/Users/Nick/.claude/hooks/obsidian-link-check.sh" }]
#     }
#   ]
# }

VAULT_PATH="C:/Users/Nick/Documents/GitHub/obsidian-vaults"

# Get the file path from tool output (Claude passes CLAUDE_TOOL_INPUT as JSON for PreToolUse,
# but for PostToolUse we parse CLAUDE_TOOL_OUTPUT for the file_path written)
# The tool input is available as CLAUDE_TOOL_INPUT env var
FILE_PATH=$(echo "${CLAUDE_TOOL_INPUT}" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)

# If no file path found or file is outside the vault, exit silently
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Normalize: check if file is inside the obsidian vault
case "$FILE_PATH" in
  *obsidian-vaults*) ;;  # inside vault, continue
  *) exit 0 ;;           # outside vault, silent exit
esac

# Only care about markdown files
case "$FILE_PATH" in
  *.md) ;;
  *) exit 0 ;;
esac

# Check unresolved link count
UNRESOLVED=$(obsidian unresolved total 2>/dev/null)
if [ $? -ne 0 ]; then
  # Obsidian not running or CLI unavailable — silent exit
  exit 0
fi

# If there are unresolved links, emit a warning
if [ -n "$UNRESOLVED" ] && [ "$UNRESOLVED" -gt 0 ] 2>/dev/null; then
  # Get the actual unresolved links to surface which ones are broken
  BROKEN=$(obsidian unresolved 2>/dev/null | head -20)
  echo "<obsidian-link-warning>"
  echo "⚠️  Vault has $UNRESOLVED unresolved link(s) after this edit."
  echo "Broken links:"
  echo "$BROKEN"
  echo "Consider fixing these with correct [[wikilinks]] or removing stale references."
  echo "</obsidian-link-warning>"
fi

exit 0
