#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


# export default path
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin"
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export BROWSER=/usr/bin/jumanji

export HISTCONTROL=ignoreboth
# export HISTIGNORE='history*'
export HISTFILE=$HOME/.bash_history
export HISTSIZE=100000
export HISTFILESIZE=200000

shopt -s histappend
shopt -s checkwinsize
shopt -s autocd

