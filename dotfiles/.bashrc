#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# is readable?
[ -r /etc/profile.d/command-not-found.bash ] && . /etc/profile.d/command-not-found.bash

# Source the aliases from separate file
if [ -e $HOME/.alias ]; then
	  [ -n "$PS1" ] && . $HOME/.alias
fi


# list dir after changing dir
cd() {
    if [ -n "$1" ]; then
        builtin cd "$@" && ls
    else
        builtin cd ~ && ls
    fi
}

# copy and go to dir
cpg() {
  if [ -d "$2" ];then
    cp $1 $2 && cd $2
  else
    cp $1 $2
  fi
}

# move and go to dir
mvg() {
  if [ -d "$2" ];then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}

# copy with progress BAR
cpv() {

    local USAGE="Jr focus! Usage:$0 SOURCE1 SOURCE2 SOURCE3 ... SOURCE DEST/"
    local ARGS=("$@")

    if [ $# -ge "2" ]; then
       if [ -d "${ARGS[1]}" ]; then
           bar -o "${ARGS[1]}" "${ARGS[0]}"
       elif [ -d "${ARGS[-1]}" ]; then
           local SOURCEDEST=${ARGS[-1]}
	       unset ARGS[$#-1]
           bar -c 'cat > '"$SOURCEDEST"'/${bar_file} ' "${ARGS[@]}"
       else
           bar -o "${ARGS[1]}" "${ARGS[0]}"
       fi
    else
       echo "$USAGE"
    fi
}

# shot - takes a screenshot of your current window
snip(){
	import -frame -strip -quality 75 "$HOME/$(date +%s).png"
}

# backup files and folder
backup(){
	cp -R $1 ${1}-`date +%Y%m%d%H%M`.backup ;
}




# concatenating files with progress BAR
catwrite(){
    local USAGE="Jr what are you doing?? Usage:$0 SRCFILE1 SRCFILE2 SRCFILE3 ... DESTFILE"
    local ARGS=("$@")

    if [ $# -ge "2" ]; then
       if [ -f "${ARGS[-1]}" ]; then
           local SOURCEFILE=${ARGS[-1]}
	       unset ARGS[$#-1]
           bar "${ARGS[@]}" > "$SOURCEFILE"
       else
           bar "${ARGS[0]}" > "${ARGS[1]}"
       fi
    else
       echo "$USAGE"
    fi

}


# write into file with progress BAR
catappend(){
    local USAGE="Jr what are you doing?? Usage:$0 SRCFILE1 SRCFILE2 SRCFILE3 ... DESTFILE"
    local ARGS=("$@")

    if [ $# -ge "2" ]; then
       if [ -f "${ARGS[-1]}" ]; then
           local SOURCEFILE=${ARGS[-1]}
	       unset ARGS[$#-1]
           bar "${ARGS[@]}" >> "$SOURCEFILE"
       else
           bar "${ARGS[0]}" >> "${ARGS[1]}"
       fi
    else
       echo "$USAGE"
    fi

}


# note taker
# add notes
# > notes messgaes to notes
# list notes with line numbers
# > notes -l
# delete selected notes by line numbers
# > notes -r


notes() {
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
		# display notes
        cat "$HOME/.notes"
    elif [[ "$1" == "-l" ]]; then
        # display notes with body numbering
        nl -b a "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
		# clear notes
       printf "%s" > $HOME/.notes
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/.notes"
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\};
        echo -n "Type a number to remove: "
        read lineNumber
        sed -i ${lineNumber}d $HOME/.notes "$HOME/.notes"
    else
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}


# detailed ip information
# eg. ipinfo 223.25.10.75
ipinfo() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
	curl ipinfo.io/"$1"
    else
	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
	curl ipinfo.io/${ipawk[1]}
    fi
    echo
}


#	myip - finds your current IP if your connected to the internet
myip(){
	lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
}



#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm /tmp/list
}

#netinfo - shows network information for your system
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}




# Filenames to lowercase. Ex.. lowercase * = All file in the current dir.
lowercase()
{
 for file ; do
  filename=${file##*/}
  case "$filename" in
     */*) dirname==${file%/*} ;;
      *) dirname=.;;
  esac
  nf=$(echo $filename | tr A-Z a-z)
  newname="${dirname}/${nf}"
  if [ "$nf" != "$filename" ]; then
      mv "$file" "$newname"
      echo "lowercase: $file --> $newname"
  else
      echo "lowercase: $file not changed."
  fi
done
}

# System Info
sysinfo(){
	clear
	num_cpus=`cat /proc/cpuinfo | grep -c "model name"`
	machine_cpu=`cat /proc/cpuinfo | grep -m 1 "model name" | cut -d: -f2`
	machine_mhz=`cat /proc/cpuinfo | grep -m 1 "cpu MHz" | cut -d: -f2`
	machine_cpuinfo=`uname -mp`
	todays_date=`date +"%D %r"`
	machine_uptime=`uptime`
	machine_ram=`cat /proc/meminfo | grep -m 1 "MemTotal:" | cut -d: -f2 |  sed 's/^[ \t]*//'`
	machine_video=`lspci | grep -m 1 "VGA" | cut -d: -f3 |  sed 's/^[ \t]*//'`
	machine_eth_card=`lspci | grep -m 1 "Ethernet" | cut -d: -f3 |  sed 's/^[ \t]*//'`
	machine_audio_controller=`lspci | grep -m 1 "audio" | cut -d: -f3 |  sed 's/^[ \t]*//'`
	arch_damons=`grep "DAEMONS=" /etc/rc.conf `
	last_logins=`last | head`
	eth0info=`ifconfig eth0 | grep "inet addr:" | sed 's/inet addr/Local IP/g' | sed 's/^[ \t]*//;s/[ \t]*$//'`

	echo "ARCH LINUX - Machine Information Script ver .10"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "DATE: $todays_date   MACHINE NAME: $HOSTNAME  "
	echo " "
	echo "Eth0: $eth0info"
	echo "ETHERNET CARD: $machine_eth_card"
	echo "CPU INFO: Qty=$num_cpus $machine_cpuinfo"
	echo "VIDEO CARD: $machine_video"
	echo "AUDIO CONTROLLER: $machine_audio_controller"
	echo "RAM INFO: $machine_ram"
	echo " "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	route
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "DISK USAGE:"
	df -h
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "UPTIME: $machine_uptime"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "$arch_damons"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}


 [ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion


