#!/bin/bash

DEFAULT_OUTPUT_DEVICE="alsa_output.pci-0000_10_00.1.hdmi-stereo"
ALTERNATIVE_OUTPUT_DEVICE="alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K3-00.analog-stereo"

function switch_output_to_device { NEW_OUTPUT_DEVICE="$1"
  echo "Switching to device $NEW_OUTPUT_DEVICE"
  notify-send -t 1000 "Switching audio output device" "to \"$NEW_OUTPUT_DEVICE\""
  ( set -x; pactl set-default-sink "$NEW_OUTPUT_DEVICE" )
}

CURRENT_OUTPUT_DEVICE=$(pactl list short sinks | grep -v PulseEffects | grep RUNNING | awk '{print $2}')
echo "Current device is $CURRENT_OUTPUT_DEVICE"

if [[ "$CURRENT_OUTPUT_DEVICE" == "$DEFAULT_OUTPUT_DEVICE" ]]; then
  switch_output_to_device "$ALTERNATIVE_OUTPUT_DEVICE"
else
  switch_output_to_device "$DEFAULT_OUTPUT_DEVICE"
fi
