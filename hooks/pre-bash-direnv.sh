#!/bin/bash
# Automatically wrap bash commands with direnv exec when .envrc exists in cwd or target dir

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
CWD=$(echo "$INPUT" | jq -r '.cwd')

# Skip if already using direnv
if [[ "$COMMAND" == direnv* ]]; then
  exit 0
fi

# Determine effective directory: check for leading 'cd <path>' in command
TARGET_DIR="$CWD"
if [[ "$COMMAND" =~ ^cd[[:space:]]+(\"?([^\"&\;[:space:]]+)\"?)[[:space:]]*(\&\&|;) ]]; then
  CANDIDATE="${BASH_REMATCH[2]}"
  CANDIDATE="${CANDIDATE/#\~/$HOME}"
  [ -d "$CANDIDATE" ] && TARGET_DIR="$CANDIDATE"
fi

# Find nearest .envrc walking up from TARGET_DIR
DIR="$TARGET_DIR"
FOUND=false
while [ "$DIR" != "/" ]; do
  if [ -f "$DIR/.envrc" ]; then
    FOUND=true
    break
  fi
  DIR="$(dirname "$DIR")"
done
[ "$FOUND" = false ] && exit 0

# Wrap command with direnv exec using target directory
echo "$INPUT" | jq \
  --arg dir "$TARGET_DIR" \
  --arg cmd "$COMMAND" \
  '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      updatedInput: (.tool_input | .command = ("direnv exec " + $dir + " bash -c " + ($cmd | @sh)))
    }
  }'
