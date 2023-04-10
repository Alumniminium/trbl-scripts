#!/bin/sh

notification_id=1000001
brightness_file='/sys/class/backlight/amdgpu_bl0/brightness'
max_brightness_file='/sys/class/backlight/amdgpu_bl0/max_brightness'
timeout=1000

max=$(cat $max_brightness_file)
cur=$(cat $brightness_file)

command=$1
inputValue=$2

if [ $command = "+" ]; then
	if [ -z $inputValue ]; then
		val=$((cur+5))
	else
		val=$((cur+inputValue))
	fi
	if [ $val -gt $max ]; then
		val=$max
	fi
	echo $val | sudo tee $brightness_file
	notify-send -t $timeout "Brightness" "$val" -r $notification_id
fi

if [ $command = '-' ]; then
	if [ -z $inputValue ]; then
		val=$((cur-5))
	else
		val=$((cur-inputValue))
	fi
	if [ 0 -gt $val ]; then
		val=0
	fi
	echo $val | sudo tee $brightness_file
	notify-send -t $timeout "Brightness" "$val" -r $notification_id
fi

if [ $command = '=' ]; then
	if [ -z $inputValue ]; then
		val=$(cat $brightness_file)
		notify-send -t $timeout "Brightness" "$val" -r $notification_id
	else
		echo $inputValue | sudo tee $brightness_file
		notify-send -t $timeout "Brightness" "$inputValue" -r $notification_id
	fi
fi

if [ $command = '-h' ]; then
	echo 'Get Brightness: backlight.sh ='
	echo 'Set Brightness: backlight.sh = 255'
	echo 'Increase by 50: backlight.sh + 75'
	echo 'Decrease by 75: backlight.sh - 75'
	echo 'Increase by 5: backlight.sh +'
	echo 'Decrease by 5: backlight.sh -'
fi
