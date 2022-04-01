# `pSoxIzsh`

## About this

Over the years I have collect various bits from various locations. I often share
what I have done with work colleagues and finally made this repository so people
can pull the latest.

This is optimized by default for dark terminals, and contains configurations for
use with

- zsh >= v5.8
- neovim >= v0.6
- tmux >= 3.2

All of these have standard setting but can be customized by using optional
include files. Please read the following configs

- `vimrc`
- `zshrc`
- `tmux/tmux.conf`

and look at the include files to check for overrides.

## Looks

For the best appearance I have tested the latest versions of

- Konsole
- Microsoft Terminal
- WezTerm
- Kitty (the Linux version, not the on based of putty)
- Alacritty (Windows and Linux)

I have previously used this on iTerm2 on MacOS but not recently.

I also use the _Iosevka Term Curly_ font on both Linux and Windows with
ligatures enabled where possible.

## Updates

If you already have an installation cd to the `~/.psoxizsh` or `/etc/psoxizsh`
as root directory and make sure you have not make any changes. If you have stash
them and then run the following commands.

```bash

(
    git pull --recurse-submodules=yes
    git submodule foreach git fetch --all --prune
    git submodule foreach git checkout master
    git submodule foreach git pull
    git pull --recurse-submodules=yes
)

src

```

## Install

### User

```bash

git clone --recurse-submodules --recursive https://github.com/psox/psoxizsh.git ~/.psoxizsh

# This should work on Linux.  It is not tested on MacOS or Windows
~/.psoxizsh/fresh-system

```

### Root - System Wide

```bash

# Make sure you are root
git clone --recurse-submodules --recursive https://github.com/psox/psoxizsh.git /etc/psoxizsh

# This should work on Linux.  It is not tested on MacOS or Windows
# for each user that wants to use this as the user run this command
/etc/psoxizsh/fresh-system

```

## Configure NeoVim

Make sure you have neovim (tested on v0.6.1) installed and after starting zsh
check that the following variable are set by typing

You will need to install `neovim`, `nodejs` and `npm` to get the full use of vim

Just start neovim (`nvim`) and wait for it to finish. After that quit and it
should be ready to use.

```bash
echo $VIMINIT
echo $MYVIMRC
echo $VIMHOME
```

Enjoy
