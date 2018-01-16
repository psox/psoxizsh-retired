# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519 ~/.ssh/.*_autoload(N)
zstyle :omz:plugins:ssh-agent lifetime 36h

# remove duplicates
typeset -U PATH path

[[ -f /etc/profile ]] && source /etc/profile

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
export ZSH=~/.psoxizsh/oh-my-zsh

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
ZSH_CUSTOM=$(dirname $ZSH)/zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh_reload
  zsh-navigation-tools
  gnu-utils
  common-aliases
  colored-man-pages
  $( which git 2>&1 >/dev/null && echo git )
  $( which git 2>&1 >/dev/null && echo git-prompt )
  $( which git 2>&1 >/dev/null && echo git-extra )
  $( which git 2>&1 >/dev/null && echo git-flow )
  $( which perl 2>&1 >/dev/null && echo perl )
  $( which go 2>&1 >/dev/null && echo go )
  $( which rsync 2>&1 >/dev/null && echo rsync )
  $( which rust 2>&1 >/dev/null && echo rust )
  $( which cargo 2>&1 >/dev/null && echo cargo )
  $( which jq 2>&1 >/dev/null && echo jsontools )
  $( which encode64 2>&1 >/dev/null && echo encode64 )
  $( which docker-compose 2>&1 >/dev/null && echo docker-compose )
  $( which docker 2>&1 >/dev/null && echo docker )
  $( which systemd 2>&1 >/dev/null && echo systemd )
  $( which python 2>&1 >/dev/null && echo python )
  $( which pip 2>&1 >/dev/null && echo pip )
  $( which sudo 2>&1 >/dev/null && echo sudo )
  $( which tmux 2>&1 >/dev/null && echo tmux )
  $( which rpmbuild 2>&1 >/dev/null && echo rpmbuild )
  $( which rpm 2>&1 >/dev/null && echo rpm )
  $( which yum 2>&1 >/dev/null && echo yum )
  $( which kubeadm 2>&1 >/dev/null && echo kubeadm )
  $( [[ -e /etc/arch-release ]] && echo archlinux )
  $( [[ -e /etc/centos-release ]] && echo fedora )
  $( [[ -e /etc/redhat-release ]] && echo redhat )
  $( [[ -e /etc/ubuntu-release ]] && echo ubuntu )
  $( [[ -e /etc/suse-release ]] && echo suse )
  $( [[ "$(uname)" == "Darwin" ]] && echo osx )
  $( which vim 2>&1 >/dev/null && echo vim-interaction )
  $( which ssh 2>&1 >/dev/null && echo ssh-agent )
  zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-history-substring-search
)

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin17.0.0" ]]
then
  export VIMINIT='source $MYVIMRC'
  export MYVIMRC=$HOME/.psoxizsh/vimrc
  export VIMHOME=$HOME/.psoxizsh/vim
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
export SSH_KEY_PATH="~/.ssh/id_ed25519"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.psoxizsh/zshrc"
alias ohmyzsh="vim ~/.psoxizsh/oh-my-zsh"
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

# vim: sw=2 ts=8 si relativenumber number
