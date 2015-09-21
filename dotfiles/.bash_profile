#
# ~/.bash_profile
#


export PATH
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export HISTIGNORE='history*'
export HISTFILE=~/.bash_history


shopt -s histappend
shopt -s autocd
shopt -s checkwinsize



set_prompt () {
    local last_command=$? # Must come first!
    PS1=""
    local blue='\[\e[01;34m\]'
    local white='\[\e[01;37m\]'
    local red='\[\e[01;31m\]'
    local cyan='\[\e[01;36m\]'
    local green='\[\e[01;32m\]'
    local reset='\[\e[00m\]'
    local fancyX='\342\234\227'
    local checkmark='\342\234\223'

  #  PS1+="$white\$? "
    if [[ $last_command == 0 ]]; then
        PS1+="$green$checkmark "
    else
        PS1+="$red$fancyX "
    fi
    if [[ $EUID == 0 ]]; then
        PS1+="$red\\h "
    else
        PS1+="$green\\u$cyan@\h "
    fi
    PS1+="$blue\\w \\\$$reset "

    
}

PROMPT_COMMAND='set_prompt'


export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

[[ -f ~/.bashrc ]] && . ~/.bashrc
