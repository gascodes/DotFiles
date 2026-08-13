#!/bin/bash

# Crear sink combinado
pactl load-module module-combine-sink \
sink_name=dual_output \
slaves=alsa_output.usb-GeneralPlus_USB_Audio_Device-00.analog-stereo,alsa_outpu>

# Establecer como salida predeterminada
pactl set-default-sink dual_output

echo "Dual output activado"
