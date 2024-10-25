#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\[\033[0;35m\]\342\224\21>


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
