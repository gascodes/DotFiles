#!/bin/bash


#
# btmenu - Gestor interactivo de dispositivos Bluetooth (con dialog) by gascodes
#
# Características principales:
# - Comprueba que estén instalados los paquetes necesarios:
#     - bluez / bluez-utils (bluetoothctl)
#     - dialog (interfaz ncurses)
# - Reinicia automáticamente el servicio de Bluetooth al iniciar.
# - Escanea dispositivos Bluetooth cercanos y los muestra en un menú interactivo.
# - Permite elegir un dispositivo y:
#     - Emparejarlo
#     - Marcarlo como de confianza
#     - Conectarlo
# - Guarda el último dispositivo conectado en ~/.last_bt_device
# - En ejecuciones posteriores:
#     - Opción de reconectar directamente al último dispositivo guardado
#     - Opción de realizar un nuevo escaneo y conectar otro dispositivo
# - Usa menús interactivos con `dialog` y muestra una barra de progreso al conectar.
#
# Instalación recomendada:
#   1. Copiar el script a /usr/local/bin con el nombre "btmenu"
#   2. Dar permisos de ejecución: sudo chmod +x /usr/local/bin/btmenu
#   3. Ejecutar simplemente con: btmenu
#



SAVE_FILE="$HOME/.last_bt_device"

# --- Comprobación de dependencias ---
check_deps() {
    missing=()

    for pkg in bluetoothctl dialog; do
        if ! command -v "$pkg" &> /dev/null; then
            missing+=("$pkg")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "❌ Faltan dependencias necesarias:"
        for m in "${missing[@]}"; do
            echo "   - $m"
        done
        echo ""
        echo "👉 Instálalas antes de continuar."
        echo "   - En Debian/Ubuntu: sudo apt install bluez bluez-utils dialog"
        echo "   - En Arch Linux:   sudo pacman -S bluez bluez-utils dialog"
        exit 1
    fi
}



restart_bluetooth() {
    echo "[*] Reiniciando Bluetooth..."
    sudo systemctl restart bluetooth
    sleep 2
}

scan_devices() {
    echo "[*] Escaneando dispositivos Bluetooth (10 segundos)..."
    rm -f /tmp/bt_scan.txt
    timeout 10s bluetoothctl scan on > /dev/null 2>&1 &
    sleep 12
    bluetoothctl devices > /tmp/bt_scan.txt
}

choose_device() {
    mapfile -t devices < <(cat /tmp/bt_scan.txt)

    if [[ ${#devices[@]} -eq 0 ]]; then
        dialog --msgbox "No se encontraron dispositivos Bluetooth." 8 40
        exit 1
    fi

    list=()
    for i in "${!devices[@]}"; do
        mac=$(echo "${devices[$i]}" | awk '{print $2}')
        name=$(echo "${devices[$i]}" | cut -d' ' -f3-)
        list+=($i "$name [$mac]")
    done

    choice=$(dialog --menu "Dispositivos Bluetooth encontrados" 20 70 10 "${list[@]}" 3>&1 1>&2 2>&3)

    if [[ -z "$choice" ]]; then
        exit 1
    fi

    selected="${devices[$choice]}"
    mac=$(echo "$selected" | awk '{print $2}')
    name=$(echo "$selected" | cut -d' ' -f3-)
    echo "$mac|$name" > "$SAVE_FILE"
}

connect_device() {
    mac="$1"
    name="$2"

    {
        echo 10; bluetoothctl pair "$mac" > /dev/null 2>&1
        echo 50; bluetoothctl trust "$mac" > /dev/null 2>&1
        echo 80; bluetoothctl connect "$mac" > /dev/null 2>&1
        echo 100
    } | dialog --gauge "Conectando a $name..." 10 70 0
}

# --- Lógica principal ---
restart_bluetooth

while true; do
    if [[ -f "$SAVE_FILE" ]]; then
        last_mac=$(cut -d'|' -f1 "$SAVE_FILE")
        last_name=$(cut -d'|' -f2- "$SAVE_FILE")
        menu=$(dialog --menu "Gestor Bluetooth" 15 60 5 \
            1 "Reconectar último: $last_name ($last_mac)" \
            2 "Escanear y elegir nuevo dispositivo" \
            3 "Salir" \
            3>&1 1>&2 2>&3)
    else
        menu=$(dialog --menu "Gestor Bluetooth" 15 60 5 \
            2 "Escanear y elegir nuevo dispositivo" \
            3 "Salir" \
            3>&1 1>&2 2>&3)
    fi

    case "$menu" in
        1)
            connect_device "$last_mac" "$last_name"
            ;;
        2)
            scan_devices
            choose_device
            connect_device "$mac" "$name"
            ;;
        3|"")
            clear
            exit 0
            ;;
        *)
            dialog --msgbox "Opción inválida" 8 40
            ;;
    esac
done
