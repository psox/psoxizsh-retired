# `pSoxIzsh`

## About this

Over the years I have collect various bits from various locations.  I often share what I have done with work colleagues and
finally made this repository so people can pull the latest.  if you already have an installation cd to the `~/.psoxizsh`
directory and make sure you have not make any changes.  If you have stash them and then run the following commands.

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

git clone --recurse-submodules --recursive --config http.sslVerify=false https://github.com/psox/psoxizsh.git ~/.psoxizsh

~/.psoxizsh/fresh-system

```

### Root - System Wide

```bash

# Make sure you are root
git clone --recurse-submodules --recursive --config http.sslVerify=false https://github.com/psox/psoxizsh.git /etc/psoxizsh

# for each user that wants to use this
/etc/psoxizsh/fresh-system

```

## Configure Vim or NeoVim

Make sure you have vim 8 installed and after starting zsh check that the following variable are set by typing

```bash
echo $VIMINIT
echo $MYVIMRC
echo $VIMHOME
```

Also check your `/etc/vimrc` or `/etc/vim/vimrc` to see if they do something funny.  A good example of a
`vimrc` that can be appended to the end of the `vimrc` file off the `/etc` directory
can be found in `~/.psoxizsh/etc/`.

If these are not set try adding the following to the beginning of your `~/.zshrc` file.

```bash
export VIMINIT='source $MYVIMRC'
export MYVIMRC=$HOME/.psoxizsh/vimrc
export VIMHOME=$HOME/.psoxizsh/vim
```

Once these values are set in your environment you can start vim and type.

```viml
:PlugInstall
```

Exit vim and start again, if you get an error with the YouCompleteMe plugin, go to the
[You Complete Me](https://github.com/Valloric/YouCompleteMe#full-installation-guide)
page and see if you can fix it.  Normally install a more complete version of vim will
solve the problem.

Enjoy
