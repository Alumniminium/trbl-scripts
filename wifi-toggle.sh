#!/bin/bash
input=$1

if [ "$input" = "status" ]; then
    state=$(rfkill -no TYPE,SOFT | grep wlan | head -n1 | cut -d ' ' -f 7)
    if [ "$state" == "" ]; then
        notify-send "WiFi enabled"
    else
        notify-send "WiFi disabled"
    fi

elif [ "$input" = "toggle" ]; then
    state=$(rfkill -no TYPE,SOFT | grep wlan | head -n1 | cut -d ' ' -f 7)
    if [ "$state" == "" ]; then
        rfkill unblock wlan
        notify-send "WiFi enabled"
    else
        rfkill block wlan
        notify-send "WiFi disabled"
    fi

elif [ "$input" = "disable" ]; then
        rfkill block wlan
        notify-send "WiFi disabled"

elif [ "$input" = "enable" ]; then
        rfkill unblock wlan
        notify-send "WiFi enabled"

else
    echo "usage: ./wifi-toggle.sh [status|toggle|enable|disable]"
fi