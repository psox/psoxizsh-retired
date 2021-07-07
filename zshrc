# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

[[ "$LANGUAGE" == "" ]] && export LANGUAGE=en_US.UTF-8
[[ "$LANG" == "" ]] && export LANG=en_US.UTF-8
[[ "$LC_ALL" == "" ]] && export LC_ALL=en_US.UTF-8

[[ -d /etc/psoxizsh ]] && export PSOXIZSH=/etc/psoxizsh
[[ -d ~/.psoxizsh ]] && export PSOXIZSH=~/.psoxizsh

[[ "$TERM" == "linux" ]] && export TERM=vte-256color

# remove duplicates
typeset -U PATH path fpath
path=( /bin /sbin /usr/bin /usr/sbin $path )
[[ -d ~/bin ]] && path=( ~/bin $path )

# sdkman support
[[ -f ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh

# nvm
[[ -f /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

# jaesve support
( which jaesve &>/dev/null ) && (
  [[ -d ~/.local/share/zsh/functions ]] || mkdir -vp ~/.local/share/zsh/functions
  [[ $(which jaesve) -nt ~/.local/share/zsh/functions/_jaesve ]] || (
    jaesve completions -- zsh > ~/.local/share/zsh/functions/_jaesve
  )
)

# Set funtion paths
foreach local p in ~/.local/share/zsh/functions ~/.config/zsh/functions $extra_fpath
  [[ -d "$p" ]] && fpath=( "$p" $fpath ) 
end

[[ "$OS" != "Windows_NT" ]] && [[ -f /etc/profile ]] && source /etc/profile

if [[ -z "$GOPATH" ]]
then
  if [[ -d /cygdrive/s/develop/go ]]
  then
    export GOPATH=$(echo /cygdrive/s/develop/go)
  elif [[ -d ~/Develop/go ]]
  then
    export GOPATH=$(echo ~/Develop/go)
  elif [[ -d ~/develop/go ]]
  then
    export GOPATH=$(echo ~/develop/go)
  else
    export GOPATH=$(echo ~/go)
  fi
fi

path+=( $GOPATH/bin ${GOROOT+${GOROOT}/bin} )

# Path to your oh-my-zsh installation.
export ZSH=$PSOXIZSH/oh-my-zsh
export ZSH_CACHE_DIR=~/.cache/zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="rkj-repos"
[[ -z $ZSH_THEME ]] && export ZSH_THEME="stemmet"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=3

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$(dirname $ZSH)/zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=( 
  $pre_plugins 
  zsh_reload
  gnu-utils 
  common-aliases 
  colored-man-pages 
)
( which git &>/dev/null ) && plugins+=( git git-extras git-flow-avh ) && [[ "$ZSH_THEME" == "stemmet" ]] && [ -z "$STARSHIP_SHELL" ] && plugins+=( git-prompt )
( which perl &>/dev/null ) && plugins+=( perl )
( which go &>/dev/null ) && plugins+=( golang )
( which oc &>/dev/null ) && plugins+=( oc )
( which rsync &>/dev/null ) && plugins+=( rsync )
( which aws &>/dev/null ) && plugins+=( aws )
( which rust &>/dev/null ) && plugins+=( rust )
( which cargo &>/dev/null ) && plugins+=( cargo )
( which jq &>/dev/null ) && plugins+=( jsontools )
( which encode64 &>/dev/null ) && plugins+=( encode64 )
( which docker-compose &>/dev/null ) && plugins+=( docker-compose )
( which docker &>/dev/null ) && plugins+=( docker )
( which mosh &>/dev/null ) && plugins+=( mosh )
( which systemd &>/dev/null ) && plugins+=( systemd )
( which python &>/dev/null ) && plugins+=( python )
( which pip &>/dev/null ) && plugins+=( pip )
( which sudo &>/dev/null ) && plugins+=( sudo )
( which tmux &>/dev/null ) && plugins+=( tmux )
( which yum &>/dev/null ) && plugins+=( yum )
( which code &>/dev/null ) && plugins+=( vscode )
( which strfile &>/dev/null ) && plugins+=( chucknorris )
( which kubectl &>/dev/null ) && plugins+=( kubectl )
( [[ -e /etc/arch-release ]] ) && plugins+=( archlinux )
( [[ -e /etc/suse-release ]] ) && plugins+=( suse )
( [[ "$(uname)" == "Darwin" ]] ) && plugins+=( osx )
#( which vim &>/dev/null ) && plugins+=( vim-interaction )
( which ssh &>/dev/null ) && [[ -d ~/.ssh ]] && plugins+=( ssh-agent )
plugins+=( 
  zsh-completions
  zsh-autosuggestions
  zsh-navigation-tools
  $( which fzf &>/dev/null && echo 'fzf' )
  zsh-syntax-highlighting
  $post_plugins
)

if [[ "$OSTYPE" =~ "linux*" || "$OSTYPE" =~ "darwin*" || "$OSTYPE" == "cygwin" ]]
then
  export VIMINIT='source $MYVIMRC'
  export MYVIMRC=$PSOXIZSH/vimrc
  export VIMHOME=~/.vim
  cmp $PSOXIZSH/vim/autoload/plug.vim $VIMHOME/autoload/plug.vim 2>/dev/null || (
    mkdir -vp $VIMHOME/autoload/
    cp -av $PSOXIZSH/vim/autoload/plug.vim $VIMHOME/autoload/plug.vim
  )
fi

if [[ -d ~/.ssh ]]
then
  zstyle :omz:plugins:ssh-agent lifetime 36h
  if [[ -e ~/.ssh/autoload ]] 
  then
      zstyle :omz:plugins:ssh-agent identities $( cat ~/.ssh/autoload )
  fi
fi

[[ -d $ZSH ]] && source $ZSH/oh-my-zsh.sh

zstyle :omz:plugins:ssh-agent agent-forwarding on

# Dynamic Completion
foreach cmd in kubectl kubeadm
  ( which $cmd &>/dev/null ) && source <($cmd completion zsh)
end

source $PSOXIZSH/zsh-custom/zshnip/zshnip.zsh
( which lxc &>/dev/null ) && source $PSOXIZSH/zsh-custom/lxd-completion-zsh/_lxc

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

( which vi &>/dev/null ) && export EDITOR='vi'
( which vim &>/dev/null ) && export EDITOR='vim'
( which nvim &>/dev/null ) && export EDITOR='nvim'

# Set zsh tmux config path
if which tmux &>/dev/null; then
  for tmux_config in {~/.config/tmux,~/.tmux,/etc/tmux}; do
    if [ -d "$tmux_config" ]; then
      TMUX_PATH="$tmux_config"
      break
    fi
  done

  [ -z "$TMUX_PATH" ] && TMUX_PATH=~/.config/tmux
  export TMUX_PATH=$TMUX_PATH

  [ -d "$TMUX_PATH" ] && [ -d "$TMUX_PATH/plugins" ] || { mkdir -vp $TMUX_PATH && cp -r $PSOXIZSH/tmux/. $TMUX_PATH }
  # If a .conf is detected override the default zsh tmux path
  [ -f "$TMUX_PATH/tmux.conf" ] && export ZSH_TMUX_CONFIG="$TMUX_PATH/tmux.conf"

  export TMUX_PLUGINS="$TMUX_PATH/plugins"
fi

if which fzf &>/dev/null; then
  # Press ? inside a C-r search to get a preview window, useful for long commands
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
  which tmux &> /dev/null && export FZF_TMUX=1
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim $PSOXIZSH/zshrc"
alias ohmyzsh="vim $PSOXIZSH/oh-my-zsh"
alias curlj="curl -H 'Content-Type: application/json' "
which nvim >/dev/null 2>&1 && alias vim="$(which nvim)"
alias v=vim
[[ -x /usr/bin/yay ]] && [[ "$(whoami)" != "pacman" ]] && alias yay='sudo -iupacman /usr/bin/yay'

typeset -A key

# setup key accordingly
bindkey -- "^[[1~" beginning-of-line
bindkey -- "^[[4~" end-of-line
bindkey -- "^[[2~" overwrite-mode
bindkey -- "^H"    backward-delete-char
bindkey -- "^[[3~" delete-char
bindkey -- "^[OD"  backward-char
bindkey -- "^[OC"  forward-char
bindkey -- "^[OA"  up-line-or-history
bindkey -- "^[OB"  down-line-or-history
#bindkey -- "^[[1;5A" history-substring-search-up
#bindkey -- "^[[1;5B" history-substring-search-down

bindkey '\ej' zshnip-expand-or-edit # Alt-J
bindkey '\ee' zshnip-edit-and-expand # Alt-E

# cutomize options
setopt no_bang_hist cdable_vars auto_name_dirs

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

[[ -d /cygdrive/c/qemu/ ]] && path+=( /cygdrive/c/qemu/ )
[[ ! -z "$DISPLAY" ]] && xhost +LOCAL:

# Set Time Variables
precmd() {
  export _DATE_=$(date -u +%Y%m%d)
  export _TIME_=$(date -u +%H%M%S)
  export _DTTS_="${_DATE_}T${_TIME_}Z"
  if [[ ! -z $KUBECONFIG ]]
  then
    export KUBE_VARS=$(basename $KUBECONFIG)/$(kubectl config current-context)
  else
    unset KUBE_VARS
  fi
}

# Remove unwanted aliases

( where fd | grep -qE '\/s?bin\/fd' ) && alias fd &>/dev/null && unalias fd

# Clean up global aliases
source <(alias -g | awk -F= '/^[A-Za-z]+/{print $1}' | xargs -I{} -n1 echo unalias "'{}'")

# vim: sw=2 ts=8 si relativenumber number
