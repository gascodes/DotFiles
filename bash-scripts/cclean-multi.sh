#!/usr/bin/env bash
# clean_update.sh — Limpieza y actualización interactiva MULTIDISTRO
# Requiere: sudo para operaciones que afectan al sistema
# Usa símbolos de Nerd Fonts; si no se ven, se mostrará texto alternativo.

# Iconos (Nerd Fonts) — puedes cambiarlos si no aparecen correctamente
ICON_MEM=""   # nf-fa-tachometer (ejemplo)
ICON_TRASH="" # nf-fa-trash_o
ICON_OK=""    # nf-fa-check
ICON_WARN=""  # nf-fa-exclamation_triangle
ICON_UP=""    # nf-fa-upload

# Función para imprimir encabezados vistosos
header() {
  local msg="$1"
  printf "\n\033[1;36m%s  %s\033[0m\n" "$ICON_MEM" "$msg"
}

subheader() {
  local msg="$1"
  printf "\033[1;33m%s  %s\033[0m\n" "$ICON_TRASH" "$msg"
}

pause() {
  read -r -p "$*"
}

# Comprueba que se ejecute en un sistema tipo Debian/Ubuntu (apt) Fedora (dnf/yum) Arch (pacman)
detect_pkg_mgr() {
  if command -v apt >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v yum >/dev/null 2>&1; then
    echo "yum"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo ""
  fi
}

PKG_MGR=$(detect_pkg_mgr)

if [ -z "$PKG_MGR" ]; then
  printf "%s No se ha detectado un gestor de paquetes compatible (apt/dnf/yum/pacman).\n" "$ICON_WARN"
  exit 1
fi

# Mostrar consumo de memoria antes
header "Memoria (antes)"
free -m

# Eliminar y vaciar cache y temporales (requiere sudo)
subheader "Limpiando caches y temporales"
echo "Se solicitarán permisos de sudo si es necesario..."
sudo_sync_succeeded=true

# 1) vaciar caches de pagecache, dentries e inodes (Linux)
if [ -w /proc/sys/vm/drop_caches ] || sudo test -w /proc/sys/vm/drop_caches; then
  printf "%s Vaciando pagecache, dentries e inodes...\n" "$ICON_TRASH"
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' || sudo_sync_succeeded=false
else
  printf "%s No se puede escribir en /proc/sys/vm/drop_caches (permiso denegado).\n" "$ICON_WARN"
fi

# 2) limpiar /tmp (eliminar archivos temporales de más de 7 días) — configurable
TMP_DAYS=7
printf "%s Eliminando archivos temporales en /tmp de más de %d días...\n" "$ICON_TRASH" "$TMP_DAYS"
sudo find /tmp -mindepth 1 -mtime +"$TMP_DAYS" -exec rm -rf {} + 2>/dev/null || true

# 3) vaciar caches de algunos gestores (apt, dnf)
if [ "$PKG_MGR" = "apt" ]; then
  printf "%s Limpiando caché de apt (apt-get clean)...\n" "$ICON_TRASH"
  sudo apt-get clean
elif [ "$PKG_MGR" = "dnf" ]; then
  printf "%s Limpiando caché de dnf (dnf clean all)...\n" "$ICON_TRASH"
  sudo dnf clean all
elif [ "$PKG_MGR" = "yum" ]; then
  printf "%s Limpiando caché de yum (yum clean all)...\n" "$ICON_TRASH"
  sudo yum clean all
elif [ "$PKG_MGR" = "pacman" ]; then
  printf "%s Limpiando caché de yum (pacman -Scc)...\n" "$ICON_TRASH"
  sudo pacman -Scc --noconfirm
fi

# 4) systemd journal: vaciar logs mayores a cierto tamaño (opcional)
JOURNAL_MAX_SIZE="10M"
if command -v journalctl >/dev/null 2>&1; then
  printf "%s Reducción de journal logs a %s (si aplica)...\n" "$ICON_TRASH" "$JOURNAL_MAX_SIZE"
  sudo journalctl --vacuum-size="$JOURNAL_MAX_SIZE" 2>/dev/null || true
fi

# Mostrar consumo de memoria después
header "Memoria (después)"
free -m

# Eliminar paquetes obsoletos / dependencias huérfanas
subheader "Eliminando paquetes obsoletos / dependencias huérfanas"
if [ "$PKG_MGR" = "apt" ]; then
  printf "%s Ejecutando: sudo apt-get autoremove -y\n" "$ICON_TRASH"
  sudo apt-get autoremove -y
  printf "%s Ejecutando: sudo apt-get autoclean -y\n" "$ICON_TRASH"
  sudo apt-get autoclean -y
elif [ "$PKG_MGR" = "pacman" ]; then
  printf "%s Ejecutando: sudo pacman -Qdtq \n" "$ICON_TRASH"
  sudo pacman -Qdtq --noconfirm | sudo pacman -Rns - --noconfirm
elif [ "$PKG_MGR" = "dnf" ] || [ "$PKG_MGR" = "yum" ]; then
  printf "%s Ejecutando: sudo %s autoremove -y (si está disponible)\n" "$ICON_TRASH" "$PKG_MGR"
  # dnf tiene 'autoremove' en versiones recientes
  if command -v "$PKG_MGR" >/dev/null 2>&1; then
    sudo $PKG_MGR autoremove -y 2>/dev/null || true
  fi
  printf "%s Limpiando metadatos: sudo %s clean all\n" "$ICON_TRASH" "$PKG_MGR"
  sudo $PKG_MGR clean all 2>/dev/null || true
fi

# Preguntar si quiere actualizar el sistema
subheader "Actualizar sistema"
while true; do
  read -r -p "¿Deseas actualizar el sistema ahora? (S/N): " yn
  case "$yn" in
    [Ss]* )
      printf "%s Iniciando actualización completa del sistema...\n" "$ICON_UP"
      if [ "$PKG_MGR" = "apt" ]; then
        sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y
      elif [ "$PKG_MGR" = "pacman" ]; then
        sudo pacman -Syyu --noconfirm
      elif [ "$PKG_MGR" = "dnf" ]; then
        sudo dnf upgrade --refresh -y
      elif [ "$PKG_MGR" = "yum" ]; then
        sudo yum update -y
      fi
      printf "%s Actualización finalizada.\n" "$ICON_OK"
      break
      ;;
    [Nn]* )
      printf "%s Actualización cancelada por el usuario.\n" "$ICON_WARN"
      break
      ;;
    * ) printf "Por favor responde S (sí) o N (no).\n";;
  esac
done

printf "\n\033[1;32m%s Operación completada.\033[0m\n" "$ICON_OK"
