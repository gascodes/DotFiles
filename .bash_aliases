alias la='ls -A'
alias ll='ls -lh'
alias l='ls -CF'

alias _="sudo"
alias x="exit"
alias xr="echo -e '\e[1;31m Reiniciando el Sistema \e[0m'; sleep 1; sudo reboot;"
alias xs="echo -e '\e[1;31m Cerrando sesion \e[0m'; sleep 1; kill -9 -1;"
alias bashrc="echo -e '\e[1;33m Reiniciando bash...\e[0m \n' && source .bashrc"

alias grub-up="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias estereo="pactl load-module module-combine-sink"


#Alias CCLEAN

alias ccl1="free -m && sync && sudo sysctl vm.drop_caches=3 && free -m && sudo find /tmp -type f -atime +10 -delete"
alias ccl2="sudo du -sh ~/.cache/ && rm -rf ~/.cache/* && sudo du -sh ~/.cache/ && sudo pacman -Scc --noconfirm"
alias ccl3="sudo pacman -Qdtq | sudo pacman -Rns - "

alias cclean="clear; echo -e '\e[1;33m   Limpiando memoria... \e[0m \n' && ccl1; echo -e '\n \e[1;33m  Limpiando cache... \e[0m \n' && ccl2; echo -e '\n \e[1;33m  Limpiando paquetes... \e[0m \n' && ccl3; "
