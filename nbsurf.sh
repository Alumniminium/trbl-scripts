#!/bin/bash

# Opens suf as a floating window
# the same size as the calling window

function get_caller()
{
    echo "$(bspc query --node focused -T | awk -F '"id":' '{print $2}' | cut -d ',' -f 1)"
}

caller=$(get_caller)

width=$(xdotool getwindowgeometry $caller  | sort | head -2 | cut -d ':' -f 2 | cut -d ' ' -f 2 | grep x | cut -d 'x' -f 1)
height=$(xdotool getwindowgeometry $caller | sort | head -2 | cut -d ':' -f 2 | cut -d ' ' -f 2 | grep x | cut -d 'x' -f 2)
x=$(xdotool getwindowgeometry $caller | sort | head -2 | grep , | cut -d ' ' -f 4 | cut -d ',' -f 1)
y=$(xdotool getwindowgeometry $caller  | sort | head -2 | grep , | cut -d ' ' -f 4 | cut -d ',' -f 2)

rect=$(echo -n $width;echo -n 'x'; echo -n $height; echo -n '+'; echo -n $x; echo -n '+'; echo -n $y)
floating=$(bspc query --node focused -T | grep -o '"state":"floating"' | wc -l)
if [[ "$@" == *"/watch"* ]]; then
    bspc rule -a mpv state floating rectangle=$rect --one-shot
	echo 'starting mpv...'
	mpv $@
elif [ $floating == 1 ]; then
    bspc rule -a Surf state floating rectangle=$rect --one-shot
	echo 'starting surf...'
    surf $@ 
else
    bspc rule -a Surf state tiled rectangle=$rect --one-shot
	echo 'starting surf...'
    surf $@
fi
