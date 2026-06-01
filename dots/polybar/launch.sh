#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# wait till the processes have been shut:
while pgrep -u  $UID -x polybar >/dev/null; do sleep 1;done

# check and launch the external monitor's Bar, monibar:
if [[ $(xrandr -q | grep 'HDMI-1 connected') ]]; then
	# Launch a bar named mainbar and monibar, sorry if anyone's confused :(
	polybar monibar &
	polybar mainbar &
else
	# launch laptop's bar only!
	polybar mainbar &
fi
