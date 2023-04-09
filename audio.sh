#!/bin/sh

action="$1"

if [ -z "$action" ]; then
    echo "Usage: $0 <get|mute|unmute|toggle|up|down>"
    exit 1
fi

notification_id="1000000"

case "$action" in
    get)
        pactl get-sink-mute @DEFAULT_SINK@
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ 1
        notify-send -r "$notification_id" "Audio Muted"
        ;;
    unmute)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        notify-send -r "$notification_id" "Audio Unmuted"
        ;;
    toggle-mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        mute_state=$(pactl get-sink-mute @DEFAULT_SINK@)
        if [ "$mute_state" = "Mute: yes" ]; then
            notify-send -r "$notification_id" "Audio Muted"
        else
            notify-send -r "$notification_id" "Audio Unmuted"
        fi
        ;;
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        current_volume=$(pactl get-sink-volume 0 | grep -oP '^\s*Volume:.*?(?=%)' | awk '{print $NF}')
        notify-send -r "$notification_id" "Volume: $current_volume"
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        current_volume=$(pactl get-sink-volume 0 | grep -oP '^\s*Volume:.*?(?=%)' | awk '{print $NF}')
        notify-send -r "$notification_id" "Volume: $current_volume"
        ;;
    *)
        echo "Invalid argument: $action"
        exit 1
esac
