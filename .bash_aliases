# Editado 22 jun 25

# Alias de Terminal
alias la='ls -A'
alias ll='ls -l'
alias _="sudo"
alias x="exit"
alias xr="sudo reboot"
alias xs="kill -9 -1"
alias xx="systemctl --poweroff"
alias bashrc="source .bashrc"

# Alias de Mantenimiento #
alias tempo="sudo find /tmp -type f -atime +10 -delete"
alias clorf="sudo pacman -Qdtq | sudo pacman -Rns -"
alias ccl="clear; free -m && sync && sudo sysctl vm.drop_caches=3 && free -m && sudo find /tmp -type f -atime +10 -delete"
alias cache="sudo du -sh ~/.cache/ && rm -rf ~/.cache/* && sudo du -sh ~/.cache/"

alias cclean="clear; echo -e '\e[1;31m  Limpiando memoria... \e[0m \n' && ccl; echo -e '\n \e[1;37m  Limpiando cache... \e[0m \n' && cache && tempo; echo -e '\n \e[1;34m  Limpiando paquetes... \e[0m \n' && clorf"
#  # Alias Grub
alias grub-up="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# Alias temporizadores 
alias offf="shutdown -h +180"
alias onnn="shutdown -c"

alias ssaver-off="xset -dpms s off"

æ Alias Fondo Pantallas
alias wallys="feh --bg-fill --randomize ~/Imágenes/Wallys/*.*"
