HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
newline=$'\n'
PROMPT="%B%F{yellow}%m%f%b:%4~$newline%# "

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if (type nvim &> /dev/null); then
   alias vim='nvim'
fi

export EDITOR=nvim
export VISUAL=nvim

setopt no_case_glob
setopt correct
setopt correct_all
setopt extendedglob
setopt NO_NOMATCH

# History
setopt append_history
setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

# Keybindings
bindkey -v
bindkey "^F" forward-word
bindkey "^B" backward-word
if [ ! -f ~/.fzf.zsh ]; then
  bindkey "^r" history-incremental-search-backward
fi
bindkey '^[[1;5C' forward-word  # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word # [Ctrl-LeftArrow] - move backward one word
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line

# Completion
unsetopt menu_complete  # do not autoselect first completion entry
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end

# Enable completions:
autoload -Uz compinit && compinit

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Git:
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT="%B%F{yellow}%m%f%b:%4~ \$vcs_info_msg_0_$newline%# "
zstyle ':vcs_info:git:*' formats '[%F{green}%b%f]'

if [[ -n "${SSH_AUTH_SOCK_LOCAL}" ]]; then
  export SSH_AUTH_SOCK="${SSH_AUTH_SOCK_LOCAL}"
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions::$FPATH

  autoload -Uz compinit
  compinit
fi

# opam configuration
[[ ! -r /Users/jon/.opam/opam-init/init.zsh ]] || source /Users/jon/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

function update_environment_from_tmux() {
  if [ -n "${TMUX}" ]; then
    eval "$(tmux show-environment -s)"
  fi
}

function title() {
   # change the title of the current window or tab
   echo -ne "\033]0;$*\007"
}

export BAT_THEME=ansi
if which bat &>/dev/null; then
  alias cat='bat -p'
fi

alias k='kubecolor'

alias cds='cd ~/work/sim'
alias cdg='cd ~/work/sim/go'

typeset -a precmd_functions
precmd_functions+=(update_environment_from_tmux)

export PATH=$(brew --prefix)/opt/openjdk/bin/:${PATH}
export PATH=~/go/bin:${PATH}

# FIXME: secretive
export SSH_AUTH_SOCK=~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/mc mc

eval "$(zoxide init zsh)"
