# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
[[ "$LANGUAGE" == "" ]] && export LANGUAGE=en_US.UTF-8
[[ "$LANG" == "" ]] && export LANG=en_US.UTF-8
[[ "$LC_ALL" == "" ]] && export LC_ALL=en_US.UTF-8

[[ -d /etc/psoxizsh ]] && export PSOXIZSH=/etc/psoxizsh
[[ -d ~/.psoxizsh ]] && export PSOXIZSH=~/.psoxizsh

# remove duplicates
typeset -U PATH path fpath
path=( /bin /sbin /usr/bin /usr/sbin $path )
[[ -d ~/bin ]] && path=( ~/bin $path )

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
( which git 2>/dev/null >/dev/null ) && plugins+=( git git-prompt git-extra git-flow-avh )
( which perl 2>/dev/null >/dev/null ) && plugins+=( perl )
( which go 2>/dev/null >/dev/null ) && plugins+=( go )
( which rsync 2>/dev/null >/dev/null ) && plugins+=( rsync )
( which aws 2>/dev/null >/dev/null ) && plugins+=( aws )
( which rust 2>/dev/null >/dev/null ) && plugins+=( rust )
( which cargo 2>/dev/null >/dev/null ) && plugins+=( cargo )
( which jq 2>/dev/null >/dev/null ) && plugins+=( jsontools )
( which encode64 2>/dev/null >/dev/null ) && plugins+=( encode64 )
( which docker-compose 2>/dev/null >/dev/null ) && plugins+=( docker-compose )
( which docker 2>/dev/null >/dev/null ) && plugins+=( docker )
( which systemd 2>/dev/null >/dev/null ) && plugins+=( systemd )
( which python 2>/dev/null >/dev/null ) && plugins+=( python )
( which pip 2>/dev/null >/dev/null ) && plugins+=( pip )
( which sudo 2>/dev/null >/dev/null ) && plugins+=( sudo )
( which tmux 2>/dev/null >/dev/null ) && plugins+=( tmux )
( which rpmbuild 2>/dev/null >/dev/null ) && plugins+=( rpmbuild )
( which rpm 2>/dev/null >/dev/null ) && plugins+=( rpm )
( which yum 2>/dev/null >/dev/null ) && plugins+=( yum )
( which strfile 2>/dev/null >/dev/null ) && plugins+=( chucknorris )
( [[ -e /etc/arch-release ]] ) && plugins+=( archlinux )
( [[ -e /etc/centos-release ]] ) && plugins+=( fedora )
( [[ -e /etc/redhat-release ]] ) && plugins+=( redhat )
( [[ -e /etc/ubuntu-release ]] ) && plugins+=( ubuntu )
( [[ -e /etc/suse-release ]] ) && plugins+=( suse )
( [[ "$(uname)" == "Darwin" ]] ) && plugins+=( osx )
( which vim 2>/dev/null >/dev/null ) && plugins+=( vim-interaction )
( which ssh 2>/dev/null >/dev/null ) && plugins+=( ssh-agent )
plugins+=( 
  zsh-completions
  zsh-autosuggestions 
  zsh-navigation-tools 
  zsh-syntax-highlighting 
  k
  $post_plugins
)

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin17.0.0" || "$OSTYPE" == "cygwin" ]]
then
  export VIMINIT='source $MYVIMRC'
  export MYVIMRC=$PSOXIZSH/vimrc
  export VIMHOME=$PSOXIZSH/vim
fi

[[ -d $ZSH ]] && source $ZSH/oh-my-zsh.sh

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities $( [[ -e ~/.ssh/autoload ]] && cat ~/.ssh/autoload )
zstyle :omz:plugins:ssh-agent lifetime 36h

# Dynamic Completion
foreach cmd in kubectl kubeadm
  ( which $cmd 2>/dev/null >/dev/null ) && source <($cmd completion zsh)
end
( which lxc 2>/dev/null >/dev/null ) && source $PSOXIZSH/zsh-custom/lxd-completion-zsh/_lxc

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim $PSOXIZSH/zshrc"
alias ohmyzsh="vim $PSOXIZSH/oh-my-zsh"
#[[ -x /usr/bin/code ]] && alias code='/usr/bin/code --user-data-dir="$(echo ~/.vscode)" '

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
[[ -x /usr/bin/yaourt ]] && alias ypac='sudo -iupacman /usr/bin/yaourt '
[[ -d /opt/Komodo-IDE-10/bin ]] && path+=( /opt/Komodo-IDE-10/bin )
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

# vim: sw=2 ts=8 si relativenumber number
