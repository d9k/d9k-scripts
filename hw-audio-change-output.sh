#!/bin/bash

DEFAULT_OUTPUT_DEVICE="alsa_output.pci-0000_10_00.1.hdmi-stereo"
ALTERNATIVE_OUTPUT_DEVICE="alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K3-00.analog-stereo"

# pacmd load-module module-stream-restore restore_device=false

function switch_output_to_device { NEW_OUTPUT_DEVICE="$1"

  # set -x
  NEW_OUTPUT_DEVICE_INDEX=$(pactl list sinks short | grep --fixed-strings "$NEW_OUTPUT_DEVICE" | awk '{print $1}' )

  if [ -z "$NEW_OUTPUT_DEVICE_INDEX" ]; then
    echo "No index for device $NEW_OUTPUT_DEVICE found"
    exit 100;
  fi

  echo "Switching to device $NEW_OUTPUT_DEVICE"
  notify-send -t 1000 "Switching audio output device" "to \"$NEW_OUTPUT_DEVICE\""
  # ( set -x; pactl set-default-sink "$NEW_OUTPUT_DEVICE" )
  ( set -x; pacmd set-default-sink "$NEW_OUTPUT_DEVICE_INDEX" )

  pactl list short sink-inputs | awk '{print $1}' | while read ID; do
    ( set -x; pacmd move-sink-input "$ID" "$NEW_OUTPUT_DEVICE_INDEX" )
  done
}

CURRENT_OUTPUT_DEVICE=$(pactl list short sinks | grep -v PulseEffects | grep RUNNING | awk '{print $2}')
echo "Current device is $CURRENT_OUTPUT_DEVICE"

if [[ "$CURRENT_OUTPUT_DEVICE" == "$DEFAULT_OUTPUT_DEVICE" ]]; then
  switch_output_to_device "$ALTERNATIVE_OUTPUT_DEVICE"
else
  switch_output_to_device "$DEFAULT_OUTPUT_DEVICE"
fi
