# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

[[ "$LANGUAGE" == "" ]] && export LANGUAGE=en_US.UTF-8
[[ "$LANG" == "" ]] && export LANG=en_US.UTF-8
[[ "$LC_ALL" == "" ]] && export LC_ALL=en_US.UTF-8

[[ -d /etc/psoxizsh ]] && export PSOXIZSH=/etc/psoxizsh
[[ -d ~/.psoxizsh ]] && export PSOXIZSH=~/.psoxizsh

# remove duplicates
typeset -U PATH path fpath
path=( /bin /sbin /usr/bin /usr/sbin $path )
[[ -d ~/bin ]] && path=( ~/bin $path )

# sdkman support
[[ -f ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh

# jaesve support
( which jaesve 2>/dev/null >/dev/null ) && (
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
( which git 2>/dev/null >/dev/null ) && plugins+=( git git-prompt git-extras git-flow-avh )
( which perl 2>/dev/null >/dev/null ) && plugins+=( perl )
( which go 2>/dev/null >/dev/null ) && plugins+=( go )
( which oc 2>/dev/null >/dev/null ) && plugins+=( oc )
( which rsync 2>/dev/null >/dev/null ) && plugins+=( rsync )
( which aws 2>/dev/null >/dev/null ) && plugins+=( aws )
( which rust 2>/dev/null >/dev/null ) && plugins+=( rust )
( which cargo 2>/dev/null >/dev/null ) && plugins+=( cargo )
( which jq 2>/dev/null >/dev/null ) && plugins+=( jsontools )
( which encode64 2>/dev/null >/dev/null ) && plugins+=( encode64 )
( which docker-compose 2>/dev/null >/dev/null ) && plugins+=( docker-compose )
( which docker 2>/dev/null >/dev/null ) && plugins+=( docker )
( which mosh 2>/dev/null >/dev/null ) && plugins+=( mosh )
( which systemd 2>/dev/null >/dev/null ) && plugins+=( systemd )
( which python 2>/dev/null >/dev/null ) && plugins+=( python )
( which pip 2>/dev/null >/dev/null ) && plugins+=( pip )
( which sudo 2>/dev/null >/dev/null ) && plugins+=( sudo )
( which tmux 2>/dev/null >/dev/null ) && plugins+=( tmux )
( which yum 2>/dev/null >/dev/null ) && plugins+=( yum )
( which code 2>/dev/null >/dev/null ) && plugins+=( vscode )
( which strfile 2>/dev/null >/dev/null ) && plugins+=( chucknorris )
( which kubectl 2>/dev/null >/dev/null ) && plugins+=( kubectl )
( [[ -e /etc/arch-release ]] ) && plugins+=( archlinux )
( [[ -e /etc/suse-release ]] ) && plugins+=( suse )
( [[ "$(uname)" == "Darwin" ]] ) && plugins+=( osx )
( which vim 2>/dev/null >/dev/null ) && plugins+=( vim-interaction )
( which ssh 2>/dev/null >/dev/null ) && [[ -d ~/.ssh ]] && plugins+=( ssh-agent )
plugins+=( 
  zsh-completions
  zsh-autosuggestions 
  zsh-navigation-tools 
  zsh-syntax-highlighting 
  $post_plugins
)

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin17.0.0" || "$OSTYPE" == "cygwin" ]]
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
  ( which $cmd 2>/dev/null >/dev/null ) && source <($cmd completion zsh)
end

source $PSOXIZSH/zsh-custom/zshnip/zshnip.zsh
( which lxc 2>/dev/null >/dev/null ) && source $PSOXIZSH/zsh-custom/lxd-completion-zsh/_lxc

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

( which vi 2>/dev/null >/dev/null ) && export EDITOR='vi'
( which vim 2>/dev/null >/dev/null ) && export EDITOR='vim'
( which nvim 2>/dev/null >/dev/null ) && export EDITOR='nvim'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim $PSOXIZSH/zshrc"
alias ohmyzsh="vim $PSOXIZSH/oh-my-zsh"
alias curlj="curl -H 'Content-Type: application/json' "

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
setopt no_bang_hist

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

[[ -x /usr/bin/yay ]] && [[ "$(whoami)" != "pacman" ]] && alias yay='sudo -iupacman /usr/bin/yay'
[[ -d /cygdrive/c/qemu/ ]] && path+=( /cygdrive/c/qemu/ )
[[ ! -z "$DISPLAY" ]] && xhost +LOCAL:

path+=( $GOPATH/bin ${GOROOT+${GOROOT}/bin} )

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

# Clean up global aliases
source <(alias -g | awk -F= '/^[A-Za-z]+/{print $1}' | xargs -I{} -n1 echo unalias "'{}'")

foreach _OPT in AUTO_NAME_DIRS CDABLE_VARS
  setopt $_OPT
end

# vim: sw=2 ts=8 si relativenumber number
