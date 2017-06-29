#!/bin/sh

userresources=$XDG_CONFIG_HOME/Xresources
usermodmap=$XDG_CONFIG_HOME/Xmodmap
userxbindkeys=$XDG_CONFIG_HOME/xbindkeys/xbindkeysrc
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -f "$userxbindkeys" ]; then
    xbindkeys -f $userxbindkeys
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto

export SSH_ASKPASS=/usr/lib/seahorse/seahorse-ssh-askpass
export XDG_CURRENT_DESKTOP=GNOME

DEFAULT_SESSION=xmonad

case $DEFAULT_SESSION in
xmonad)
    xmonad-set-wallpaper.sh &
    xmonad-autostart.sh &
    #xmonad-bar.sh &
    exec xmonad
    ;;
awesome)
    exec awesome
    ;;
*)
    exec $1
    ;;
esac
