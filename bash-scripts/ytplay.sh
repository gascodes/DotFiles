#!/usr/bin/env bash

# Descripción:
#   Solicita al usuario una dirección de YouTube, permite elegir una resolución
#   máxima de reproducción y abre el video utilizando mpv y yt-dlp.
#
# Resoluciones disponibles:
#   - 360p
#   - 480p
#   - 720p
#
# Características:
#   - Reproduce videos de YouTube con mpv.
#   - Permite seleccionar la resolución máxima.
#   - Ejecuta mpv en segundo plano.
#   - mpv continúa abierto aunque se cierre la terminal.
#   - Guarda la salida de mpv en "$HOME/mpv.log".



read -rp "Ingresa la dirección de YouTube: " url

if [[ -z "$url" ]]; then
    echo "No ingresaste ninguna dirección."
    exit 1
fi

echo
echo "Selecciona la resolución máxima:"
echo "1) 360p"
echo "2) 480p"
echo "3) 720p"

read -rp "Opción [1-3]: " opcion

case "$opcion" in
    1)
        resolucion=360
        ;;
    2)
        resolucion=480
        ;;
    3)
        resolucion=720
        ;;
    *)
        echo "Opción inválida."
        exit 1
        ;;
esac

if ! command -v mpv >/dev/null 2>&1; then
    echo "Error: mpv no está instalado."
    exit 1
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
    echo "Error: yt-dlp no está instalado."
    exit 1
fi

formato="bestvideo[height<=${resolucion}]+bestaudio/best[height<=${resolucion}]"

nohup mpv \
    --ytdl-format="$formato" \
    "$url" \
    > "$HOME/mpv.log" 2>&1 < /dev/null &

disown

echo "mpv está reproduciendo el video hasta ${resolucion}p."
echo "Puedes cerrar la terminal sin cerrar mpv."
