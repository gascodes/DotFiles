<h3>PKGLIST INSTALL</h3>
List of packages starting with a clean installation of ARCH, both for official and aur packages.<br>
<br>
<b>Help</b><br>
Install official packages <br>
<code>sudo pacman -S --needed -< pkglist-noaur.txt</code><br>
Install AUR packages<br>
<code>sudo pacman -S -< pkglist-aur.txt</code><br>
<br>
Install official packages<br>
<code>sudo pacman -S --needed -< pkglist-noaur.txt</code><br>
Install AUR packages<br>
<code>sudo pacman -S -< pkglist-aur.txt</code>
<br>
Back both types of packages<br>
<code>sudo pacman -Qqe > pkglist-aur.txt && sudo pacman -Qqe -n > pkglist-noaur.txt</code>



