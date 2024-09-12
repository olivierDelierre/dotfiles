# Exposing this flag since my company profile overwrite
# tab usage.
SHOULD_USE_FZF=true;

[ -f ~/.company.zsh ] && source ~/.company.zsh

# Path
export PATH=/opt/flutter/bin:~/bin:~/.local/bin:$PATH

# Saving Zinit HOME path
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it does not exist
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh" 

# Plugins installation
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

if $SHOULD_USE_FZF; then
  zinit light Aloxaf/fzf-tab
fi

# Load completions
autoload -U compinit && compinit

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/zen.toml)"

# Aliases
alias n=nvim
alias vim=nvim
alias ls='ls --color'
alias ll='ls -l --color'
alias la='ls -la --color'
alias cd=z

# Key mapping
bindkey '^f' autosuggest-accept

# History configuration
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

if $SHOULD_USE_FZF; then
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

  eval "$(fzf --zsh)"
fi

eval "$(zoxide init zsh)"
