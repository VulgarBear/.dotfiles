# ZINIT Download and Load
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light spaceship-prompt/spaceship-prompt

# Load completions
autoload -U compinit $$ compinit

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias ls='ls --color'
alias cd="z"
alias vim="nvim"
alias cls="clear"
alias docker-compose="docker compose"
alias pbcopy="xsel --input --clipboard"
alias pbpaste="xsel --output --clipboard"
alias reload="source ~/.zshrc"

# Git Aliases
alias gs="git status --short"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gu="git pull"
alias gl="git log"
alias gb="git branch"
alias gi="git init"
alias gcl="git clone" # This loads nvm bash_completion

# Zoxide
eval "$(zoxide init zsh)"

# FNM
FNM_PATH="/home/vulgarbear/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/vulgarbear/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
