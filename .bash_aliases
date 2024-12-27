
# Alias definitions.

alias la='ls -A'

alias _="sudo"
alias x="exit"
alias xr="sudo reboot"
alias xs="kill -9 -1"

alias bashrc="source .bashrc"

alias tempo="sudo find /tmp -type f -atime +10 -delete"
alias clorf="sudo pacman -Qdtq | sudo pacman -Rns -"
alias ccl="clear; free -m && sync && sudo sysctl vm.drop_caches=3 && free -m && sudo find /tmp -type f -atime +10 -delete"
alias cache="sudo du -sh ~/.cache/ && rm -rf ~/.cache/* && sudo du -sh ~/.cache/"

alias cclean="clear; echo -e '\e[1;31m  Limpiando memoria... \e[0m \n' && ccl; echo -e '\n \e[1;37m  Limpiando cache... \e[0m \n' && cache && tempo; echo -e '\n \e[1;34m  Limpiando paquetes... \e[0m \n' && clorf"
  




alias grub-up="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias offf="shutdown -h +180"
alias onnn="shutdown -c"

alias wallys="feh --bg-fill --randomize ~/Imágenes/Wallys/*.*"


alias ssaver-off="xset -dpms s off"
