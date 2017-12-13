# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# remove duplicates
typeset -U PATH path

[[ -f /etc/profile ]] && source /etc/profile

if [[ -z "$GOPATH" ]]
then
  if [[ -d /cygdrive/s/develop/go ]]
  then
    export GOPATH=$(echo /cygdrive/s/develop/go)
  else
    export GOPATH=$(echo ~/go)
  fi
fi

# Path to your oh-my-zsh installation.
export ZSH=~/.stemmet/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="rkj-repos"
ZSH_THEME="stemmet"

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
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  $( which git 2>&1 >/dev/null && echo git )
  $( which git 2>&1 >/dev/null && echo git-prompt )
  $( which git 2>&1 >/dev/null && echo git-extra )
  zsh_reload
  perl
  go
  rsync
  zsh-navigation-tools
  $( which rust 2>&1 >/dev/null && echo rust )
  $( which cargo 2>&1 >/dev/null && echo cargo )
  jsontools
  gnu-utils
  encode64
  $( which docker-compose 2>&1 >/dev/null && echo docker-compose )
  $( which docker 2>&1 >/dev/null && echo docker )
  common-aliases
  colored-man-pages
  systemd
  python
  pip
  sudo
  redhat
  $( which tmux 2>&1 >/dev/null && echo tmux )
  $( which rpmbuild 2>&1 >/dev/null && echo rpmbuild )
  $( which rpm 2>&1 >/dev/null && echo rpm )
  $( which yum 2>&1 >/dev/null && echo yum )
  $( which kubeadm 2>&1 >/dev/null && echo kubeadm )
  vim-interaction
  ssh-agent
  zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-history-substring-search
)

if [[ "$OSTYPE" == "linux-gnu" ]]
then
  grep  -q -i centos /etc/*-release 2>/dev/null && plugins=( $plugins fedora )
  grep  -q -i archlinux /etc/*-release 2>/dev/null && plugins=( $plugins archlinux )
  export VIMINIT='source $MYVIMRC'
  export MYVIMRC=$HOME/.stemmet/vimrc
  export VIMHOME=$HOME/.stemmet/vim
fi

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.stemmet/zshrc"
alias ohmyzsh="vim ~/.stemmet/oh-my-zsh"
[[ -x /usr/bin/code ]] && alias code='/usr/bin/code --user-data-dir="$(echo ~/vscode)" '

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
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

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

[[ -x /usr/bin/yaourt ]] && alias ypac='sudo -iupacman /usr/bin/yaourt '
[[ -d /opt/Komodo-IDE-10/bin ]] && path+=( /opt/Komodo-IDE-10/bin )
[[ -d /cygdrive/c/qemu/ ]] && path+=( /cygdrive/c/qemu/ )
[[ ! -z "$DISPLAY" ]] && xhost +LOCAL:

path+=( $GOPATH/bin ${GOROOT+${GOROOT}/bin} )

function image_env 
{ 
  [[ ! -z "$1" ]] && local name=$1 || local name=stemma 
  [[ ! -z "$2" ]] && local number=$2 || local number=9
  [[ ! -z "$3" ]] && export BASE_TAR=$3
  [[ ! -z "$4" ]] && export DISKIMAGE_TAR=$4
  [[ ! -z "$5" ]] && export WORKING_PATH=$5
  export FQDN="$name-$number.mpe.lab.vce.com"
  export IP="10.239.132.$number"
  export GATEWAY_IP="10.239.132.1"
  export NETMASK="255.255.252.0"
  export DNS_1="10.239.128.100"
  export DNS_2="10.136.112.220"
  export ROOT_PASSWORD='V1rtu@1c3!'
  export USER_NAME='dellemc'
  export USER_PASSWORD='Abcd123$'
  export SCRIPT_DEBUG=0
  [[ -z "$WORKING_PATH" ]] && export WORKING_PATH=/home/ova-build
}

function image_latest
{
  export BASE_TAR="http://$(hostname -f)/dl/$(cd ~http/dl/ ; ls centos*.txz | tail -n1)"
  export DISKIMAGE_TAR="http://$(hostname -f)/dl/$(cd ~http/dl/ ; ls base-vmdk*.txz | tail -n1)"
}

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519
zstyle :omz:plugins:ssh-agent lifetime 36h

# vim: sw=2 ts=8 si relativenumber number
