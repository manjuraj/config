# .bash_profile
#
# @author: Manju.
# @email: manj@cs.stanford.edu
# @lastedited: 06/25/2012

if [ -f ~/.profile ]; then
    source ~/.profile
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

export BASH_ENV=$HOME/.bashrc
