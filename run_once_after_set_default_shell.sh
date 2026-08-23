#!/bin/bash
# Sets zsh as the default login shell, if it isn't already.
# Safe to re-run; only acts when a change is actually needed.

set -euo pipefail

# Bail quietly if zsh isn't installed for some reason
if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh not found on PATH, skipping default shell change."
  exit 0
fi

ZSH_PATH="$(command -v zsh)"
TARGET_USER="${USER:-$(id -un)}"

# Figure out the current login shell in a cross-platform way
if command -v getent >/dev/null 2>&1; then
  CURRENT_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"
elif [ "$(uname -s)" = "Darwin" ]; then
  CURRENT_SHELL="$(dscl . -read "/Users/$TARGET_USER" UserShell 2>/dev/null | awk '{print $2}')"
else
  CURRENT_SHELL="${SHELL:-}"
fi

if [ "$CURRENT_SHELL" = "$ZSH_PATH" ]; then
  echo "zsh is already the default shell for $TARGET_USER, skipping."
  exit 0
fi

# Use sudo unless we're already root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# chsh will refuse a shell that isn't registered in /etc/shells
if [ -f /etc/shells ] && ! grep -qx "$ZSH_PATH" /etc/shells; then
  echo "Registering $ZSH_PATH in /etc/shells"
  echo "$ZSH_PATH" | $SUDO tee -a /etc/shells >/dev/null
fi

echo "Setting default shell to $ZSH_PATH for $TARGET_USER"
if $SUDO chsh -s "$ZSH_PATH" "$TARGET_USER"; then
  echo "Default shell changed to $ZSH_PATH. Log out and back in (or start a new session) for it to take effect."
else
  echo "chsh failed. You can change it manually with: chsh -s $ZSH_PATH"
fi
