#!/usr/bin/env bash

# define aspect ratios and sizes
ASPECT_RATIOS=("16:9" "4:3")
SIZES_16_9=("640x360" "1280x720" "1600x900" "1920x1080")
SIZES_4_3=("640x480" "1024x768" "1280x960" "1600x1200")

# parse arguments
if [ $# -ne 1 ]; then
    notify-send "Usage: $0 aspect_ratio" >&2
    notify-send $@
    exit 1
fi

aspect_ratio=$1

# check if aspect ratio is supported
if ! echo "${ASPECT_RATIOS[@]}" | grep -qw "$aspect_ratio"; then
    notify-send "Unsupported aspect ratio: $aspect_ratio" >&2
    exit 1
fi

# get current window id
wid=$(xdotool getactivewindow)

# get current window size and aspect ratio
size=$(xdotool getwindowgeometry --shell $(xdotool getactivewindow) | awk -F '=' '/WIDTH|HEIGHT/ {print $2}' | paste -sd 'x')
width=$(echo "$size" | awk -F "x" '{print $1}')
height=$(echo "$size" | awk -F "x" '{print $2}')
if [ -z "$width" ] || [ -z "$height" ]; then
    notify-send "Failed to get window size" >&2
    exit 1
fi
ratio=$(echo "scale=2; $width / $height" | bc)

# get closest size for requested aspect ratio
if [ "$aspect_ratio" == "16:9" ]; then
    sizes=("${SIZES_16_9[@]}")
else
    sizes=("${SIZES_4_3[@]}")
fi

closest_size=""
for s in "${sizes[@]}"; do
    s_ratio=$(echo "$s" | awk -F "x" '{printf "%.2f", $1/$2}')
    if [ -z "$closest_size" ] || \
       echo "$ratio-$s_ratio" | bc -l | awk '{printf "%.10f", $0}' | awk '{if ($1<0) printf "%.10f\n", -$1; else printf "%.10f\n", $1}' | awk '{if ($1<0.0001) print 1; else print 0}' | grep -qw "1"; then
        closest_size="$s"
    fi
done


# cycle through sizes on subsequent runs
if [ -f "/tmp/aspect_sizes_$aspect_ratio" ]; then
    idx=$(cat "/tmp/aspect_sizes_$aspect_ratio")
    next_idx=$(( (idx + 1) % ${#sizes[@]} ))
    echo $next_idx > "/tmp/aspect_sizes_$aspect_ratio"
    size=${sizes[$idx]}
else
    echo "0" > "/tmp/aspect_sizes_$aspect_ratio"
fi

if [ "$size" ]; then
    new_width=$(echo "$size" | awk -F "x" '{print $1}')
    new_height=$(echo "$size" | awk -F "x" '{print $2}')
    xdotool windowsize $wid $new_width $new_height
    notify-send "Resized window to $size"
fi