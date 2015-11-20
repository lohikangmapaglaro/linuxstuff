#! /bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

## Ensure that the D-Bus Communication System is running properly to fix
## File management, authentication, and other essential system processes

if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

## Ensure that GTK themes are applied uniformly in the Desktop Environment

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"


#start mpd daemon
[ ! -s /var/lib/mpd/mpd.pid ] && mpd &


# start vncserver
vncserver -geometry 4160x900 -alwaysshared -dpi 96 :1 &


# start tigerVNC server for local X displays
x0vncserver -display :0 -passwordfile ~/.vnc/passwd &


#init display
. $HOME/repos/linuxstuff/dotfiles/.config/i3/default/init.sh;


# start Thunar instance
thunar --daemon &

# invert numlock LED
xdotool key Num_Lock &


# start
exec i3


# exec i3 -V  --shmlog-size=26214400 >> ~/.i3.log 2>&1
# run urxvt as a daemon
sleep 4
exec i3-msg -t command reload


# Disable monitors energy savings features
xset dpms 0 0 0
xset -dpms
# Screen Saver Off
xset s off
