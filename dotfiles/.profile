# /etc/profile

if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi




# MPD daemon start (if no other user instance exists)
# [ ! -s /var/lib/mpd/mpd.pid ] && mpd
#Set our umask
# umask 022

# Set our default path
# PATH="/usr/local/sbin:/usr/local/bin:/usr/bin"

