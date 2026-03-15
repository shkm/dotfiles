#!/bin/bash
# Guard sensitive files from Claude Code access.
# Runs as a PreToolUse hook — blocks Read/Write/Edit on sensitive paths
# and catches obvious bash commands referencing them.

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input')

deny() {
  jq -n --arg reason "$1" '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": $reason
    }
  }'
  exit 0
}

# Sensitive directories (anything under these is blocked)
SENSITIVE_DIRS=(
  "$HOME/.ssh"
  "$HOME/.gnupg"
  "$HOME/.aws"
  "$HOME/.config/gcloud"
  "$HOME/.kube"
  "$HOME/.docker"
  "$HOME/.config/gh"
  "$HOME/.bundle"
  "$HOME/.cargo/credentials"
)

# Sensitive individual files
SENSITIVE_FILES=(
  "$HOME/.netrc"
  "$HOME/.git-credentials"
  "$HOME/.pypirc"
)

# Allowed exceptions (e.g. public keys)
ALLOWED_PATTERNS=(
  "$HOME/.ssh/*.pub"
)

is_allowed() {
  local p="$1"
  for pattern in "${ALLOWED_PATTERNS[@]}"; do
    # shellcheck disable=SC2254
    [[ "$p" == $pattern ]] && return 0
  done
  return 1
}

# Check if an absolute path is sensitive
is_sensitive_path() {
  local p="$1"

  # Expand ~ if present
  p="${p/#\~/$HOME}"

  # Make relative paths absolute using cwd from hook input
  if [[ "$p" != /* ]]; then
    local cwd
    cwd=$(echo "$INPUT" | jq -r '.cwd')
    p="$cwd/$p"
  fi

  is_allowed "$p" && return 1

  for dir in "${SENSITIVE_DIRS[@]}"; do
    [[ "$p" == "$dir" || "$p" == "$dir"/* ]] && return 0
  done

  for f in "${SENSITIVE_FILES[@]}"; do
    [[ "$p" == "$f" ]] && return 0
  done

  # .env files anywhere
  local base
  base=$(basename "$p")
  [[ "$base" == ".env" || "$base" == .env.* ]] && return 0

  # .kamal/secrets
  [[ "$p" == *"/.kamal/secrets" ]] && return 0

  return 1
}

case "$TOOL_NAME" in
Read | Write | Edit)
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
  if [[ -n "$FILE_PATH" ]] && is_sensitive_path "$FILE_PATH"; then
    deny "Blocked: $FILE_PATH is a protected path"
  fi
  ;;
Bash)
  CMD=$(echo "$TOOL_INPUT" | jq -r '.command // empty')

  # Block piping remote code to shell (curl|bash, wget|sh, etc.)
  if [[ "$CMD" =~ (curl|wget)[[:space:]].*[|][[:space:]]*(bash|sh|zsh|fish|source) ]]; then
    deny "Blocked: don't pipe remote code directly to shell — download and review first"
  fi

  # Block rm — use trash instead.
  # Match rm as a command (start of line, after pipe/semicolon/&&/||, or after sudo/xargs)
  # but not as a flag like --rm.
  if [[ "$CMD" =~ (^|[;\|&]|sudo|xargs)[[:space:]]*rm([[:space:]]|$) ]]; then
    deny "Blocked: use 'trash' instead of 'rm'"
  fi

  # git reset --hard — destroys uncommitted work
  if [[ "$CMD" =~ git[[:space:]].*reset[[:space:]].*--hard ]]; then
    deny "Blocked: 'git reset --hard' destroys uncommitted work"
  fi
  # git checkout . / git restore . — reverts ALL working changes
  if [[ "$CMD" =~ git[[:space:]].*checkout[[:space:]]+\.([[:space:]]|$) ]]; then
    deny "Blocked: 'git checkout .' reverts all working changes"
  fi
  if [[ "$CMD" =~ git[[:space:]].*restore[[:space:]]+\.([[:space:]]|$) ]]; then
    deny "Blocked: 'git restore .' reverts all working changes"
  fi
  # git push --force / -f — but allow --force-with-lease
  if [[ "$CMD" =~ git[[:space:]].*push[[:space:]].*--force([[:space:]]|$) ]]; then
    deny "Blocked: use '--force-with-lease' instead of '--force'"
  fi
  if [[ "$CMD" =~ git[[:space:]].*push[[:space:]].*[[:space:]]-f([[:space:]]|$) ]]; then
    deny "Blocked: use '--force-with-lease' instead of '-f'"
  fi
  # git branch -D — force delete without checks
  if [[ "$CMD" =~ git[[:space:]].*branch[[:space:]].*-[a-zA-Z]*D ]]; then
    deny "Blocked: 'git branch -D' force-deletes a branch; use '-d' instead"
  fi

  # Best-effort check for sensitive paths in bash commands.
  # Not as strong as OS-level sandbox — catches accidental access, not adversarial.
  # Each sensitive path in three forms:
  #   /Users/jamie/...  (from $HOME expansion at array init)
  #   ~/...             (literal tilde in command)
  #   $HOME/...         (literal $HOME in command — not yet expanded)
  BASH_PATTERNS=(
    "$HOME/.ssh" "~/.ssh" '$HOME/.ssh' '${HOME}/.ssh'
    "$HOME/.gnupg" "~/.gnupg" '$HOME/.gnupg' '${HOME}/.gnupg'
    "$HOME/.aws" "~/.aws" '$HOME/.aws' '${HOME}/.aws'
    "$HOME/.config/gcloud" "~/.config/gcloud" '$HOME/.config/gcloud' '${HOME}/.config/gcloud'
    "$HOME/.kube" "~/.kube" '$HOME/.kube' '${HOME}/.kube'
    "$HOME/.docker" "~/.docker" '$HOME/.docker' '${HOME}/.docker'
    "$HOME/.config/gh" "~/.config/gh" '$HOME/.config/gh' '${HOME}/.config/gh'
    "$HOME/.netrc" "~/.netrc" '$HOME/.netrc' '${HOME}/.netrc'
    "$HOME/.git-credentials" "~/.git-credentials" '$HOME/.git-credentials' '${HOME}/.git-credentials'
    "$HOME/.cargo/credentials" "~/.cargo/credentials" '$HOME/.cargo/credentials' '${HOME}/.cargo/credentials'
    "$HOME/.pypirc" "~/.pypirc" '$HOME/.pypirc' '${HOME}/.pypirc'
    "$HOME/.bundle/config" "~/.bundle/config" '$HOME/.bundle/config' '${HOME}/.bundle/config'
  )
  for pattern in "${BASH_PATTERNS[@]}"; do
    if [[ "$CMD" == *"$pattern"* ]]; then
      deny "Blocked: command references protected path ($pattern)"
    fi
  done
  ;;
esac

exit 0
