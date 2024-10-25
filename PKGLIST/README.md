<h3>PKGLIST INSTALL</h3>
List of packages starting with a clean installation of ARCH, both for official and aur packages.

<b>Help</b> 
Install official packages
<code> sudo pacman -S --needed -< pkglist-noaur.txt</code>
Install AUR packages
<code> sudo pacman -S -< pkglist-aur.txt</code>

Install official packages
<code> sudo pacman -S --needed -< pkglist-noaur.txt</code>
Install AUR packages
<code> sudo pacman -S -< pkglist-aur.txt</code>

Back both types of packages
<code>sudo pacman -Qqe > pkglist-aur.txt && sudo pacman -Qqe -n > pkglist-noaur.txt</code>



