#!/usr/bin/env zsh

pkill picom
cd /home/trbl/.wine/drive_c/Games/GothicReturning/system/
bspc rule -a \* -o state=floating && ./Gothic2.exe
cd ..
notify-send "Gothic Exited. Backing up saves..."
rsync -r saves /mnt/homeserver/mnt/4TB/Backups/Matebook/Gothic2/
notify-send "Backup finished."
picom -b --experimental-backends
