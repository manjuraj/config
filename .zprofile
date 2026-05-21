# ~/.zprofile — login shell only (PATH, env vars)
# Runs once per login session, not on every subshell.

# nix (survives macOS updates that wipe /etc/zshrc)
[[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] && \
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true

# node (via homebrew)
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# python (unversioned symlinks: python, pip, etc.)
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"

# editor
export EDITOR="vim"
export VISUAL="$EDITOR"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git/*" -I'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --line-range=:200 --color=always {} 2>/dev/null || head -n 200 {}"'

# uv / rustup (guard in case file doesn't exist)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
