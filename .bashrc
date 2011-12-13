# ~/.bashrc - executed by bash(1) for non-login shells.
#
# @author: Manju.
# @email: manj@cs.stanford.edu
# @lastedited: 10/10/2010

#
# History options.
#

# Info: searching previous commands in bash.
# -  type CTRL R and you will get a new command prompt. Then start typing
#    part of the command.  To keep looking back through other instances
#    of the command just keep hitting CTRL R.

# Save more commands.
export HISTSIZE=100000
export HISTFILESIZE=100000

# Don't put duplicate lines in the history.
export HISTCONTROL=ignoredups

# Ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files.
# see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

#
# Prompt.
#
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# set a fancy prompt - color or non-color.
case "$TERM" in
xterm-color)
    # color prompt.
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
    ;;
*)
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    # force color prompt
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '
    ;;
esac

#
# Source Aliases
#
# See /usr/share/doc/bash-doc/examples in the bash-doc package
#
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#
# Source User-defined Bash Functions
#
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

#
# Misc :)
#

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#
# My customization
#
if [ -f ~/.bash_m ]; then
    . ~/.bash_m
fi

#
# Private customization
#
if [ -f ~/.bash_private ]; then
    . ~/.bash_private
fi

#
# Help
#
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

