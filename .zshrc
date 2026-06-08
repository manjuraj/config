# history
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=200000
SAVEHIST=200000
setopt share_history inc_append_history hist_ignore_all_dups \
       hist_expire_dups_first hist_ignore_space hist_verify

# options
setopt autocd interactivecomments no_beep PROMPT_SUBST

# keys
bindkey -e
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# aliases
if ls --color=auto / &>/dev/null; then
  alias ls='ls --color=auto'  # GNU (nix coreutils)
else
  alias ls='ls -G'            # BSD (macOS)
fi
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lha'
alias lsd='ls -d */'
alias cls='printf "\e[H\e[2J\e[3J"'
alias grep='grep --color=auto'

# functions
glow_p() { glow -p -w "$COLUMNS" "$1";}
alias gp='glow_p'

# named directories
hash -d dev="$HOME/Development"
hash -d c="$HOME/Development/config"
hash -d m="$HOME/Development/Mad-Labs"
hash -d flake="$HOME/Development/flake"
hash -d notes="$HOME/Google Drive/My Drive/notes"
hash -d cvl="$HOME/Development/Crestview-Labs"

# prompt — two-line: path + git on line 1, input on line 2
autoload -Uz vcs_info add-zsh-hook

VIRTUAL_ENV_DISABLE_PROMPT=1  # we handle venv display ourselves

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%f%u%c'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b%f %F{red}(%a)%f%u%c'

_my_prompt_precmd() {
  vcs_info
  # Show ? for untracked files
  _prompt_untracked=''
  if git rev-parse --is-inside-work-tree &>/dev/null && [[ -n $(git ls-files --others --exclude-standard 2>/dev/null | head -1) ]]; then
    _prompt_untracked='%F{white}!%f'
  fi
  PROMPT='%F{blue}%~%f${vcs_info_msg_0_}${_prompt_untracked}
%(?.%F{green}.%F{red})❯%f '

  if [[ -n $IN_NIX_SHELL ]]; then
    PROMPT="%F{magenta}(nix)%f ${PROMPT}"
  fi

  if [[ -n $VIRTUAL_ENV ]]; then
    PROMPT="%F{green}(${VIRTUAL_ENV:t})%f ${PROMPT}"
  fi
}
add-zsh-hook precmd _my_prompt_precmd

# completion — rebuild dump once per day, style the menu
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# fzf (keybinds + completion are interactive, so they stay in .zshrc)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# plugins (install: brew install zsh-autosuggestions zsh-syntax-highlighting)
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# direnv (after plugins, before syntax-highlighting)
eval "$(direnv hook zsh)"

# syntax-highlighting must be sourced LAST
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
