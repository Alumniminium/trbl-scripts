#!/usr/bin/env bash

# Get WM_CLASS of foreground window

pid=$(xdotool getactivewindow)
class=$(xprop -id $pid | grep WM_CLASS | cut -d '"' -f 2)

window=$(xdotool getactivewindow getwindowname)

notify-send "Window: $window" "Class: $class"
xdotool key Ctrl+w

#if [[ $window =~ "Chromium" ]]; then

#fi
