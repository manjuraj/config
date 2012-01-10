# .bash_profile
#
# @author: Manju.
# @email: manj@cs.stanford.edu
# @lastedited: 10/10/2010

if [ -f ~/.profile ]; then
    . ~/.profile
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export BASH_ENV=$HOME/.bashrc
