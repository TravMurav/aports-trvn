#!/bin/sh
# SPDX-License-Identifier: MIT

export LD_LIBRARY_PATH=/usr/lib/xash3d
export XASH3D_EXTRAS_PAK1=/usr/share/xash3d/valve/extras.pak
export XASH3D_BASEDIR=$HOME/.xash3d 

GAME_NAME="valve"
REFDIR="/usr/lib/xash3d"

if [ ! -d $HOME/.xash3d/$GAME_NAME ]; then
	zenity --error --text="No game data found!\nCopy \"$GAME_NAME\" dir from Steam Half-Life distribution into \"~/.xash3d\""
	exit 1
fi

refs=""
for r in $REFDIR/libref*
do
	echo $(basename $r)
	refs="$refs $(basename $r)"
done

chosen_ref=$(zenity --list --text="Select graphic backend" --column=ref $refs | sed 's/libref_\(.*\)\.so/\1/')
lib_arch=$(basename /usr/lib/hlsdk/$GAME_NAME/dlls/* | sed 's/hl_\(.*\)\.so/\1/')

if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ "$QT_QPA_PLATFORM" = "wayland" ]; then
	export SDL_VIDEODRIVER=wayland
fi

/usr/lib/xash3d/xash3d \
	-dll /usr/lib/hlsdk/$GAME_NAME/dlls/hl_$lib_arch.so \
	-clientlib /usr/lib/hlsdk/$GAME_NAME/cl_dlls/client_$lib_arch.so \
	-ref $chosen_ref \
	$@

