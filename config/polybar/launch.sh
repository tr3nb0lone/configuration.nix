#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# wait till the processes have been shut:
while pgrep -u  $UID -x polybar >/dev/null; do sleep 1;done


# Launch a bar named `bar`
polybar mainbar &

# check and launch the external monitor's Bar, monibar:
if [[ $(xrandr -q | grep 'HDMI-1 connected') ]]; then
	polybar monibar &
fi

