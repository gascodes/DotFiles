#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'


PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '



if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Prompt aleatorio
if [ -f ~/.bash_prompts ]; then
    source ~/.bash_prompts
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_timer
fi
