set fish_greeting ""

# PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH /usr/local/bin $PATH
set -gx PATH $HOME/.cabal/bin $PATH

# XDG
set -gx XDG_CONFIG_HOME /home/christian/.config
set -gx XDG_DATA_HOME /home/christian/.local/share
set -gx XDG_CACHE_HOME /home/christian/.cache
set -gx XDG_RUNTIME_DIR /run/user/(id -u)

# tmux
set -gx TMUX_TMPDIR $XDG_RUNTIME_DIR

# GTK+
set -gx NO_AT_BRIDGE 1
set -gx GTK_OVERLAY_SCROLLING 0

# pacaur build dir
set -gx BUILDDIR /tmp

# make
set -gx MAKEFLAGS "-j9"

# xauth
set -gx XAUTHORITY $XDG_CACHE_HOME/Xauthority

# fzf
set -gx FZF_DEFAULT_OPTS " --color fg:-1,bg:-1,hl:33,fg+:254,bg+:0,hl+:33 --color info:136,prompt:136,pointer:230,marker:230,spinner:136"
set -gx FZF_CTRL_T_OPTS " --preview='head -$LINES {}'"

# Firefox
set -gx MOZ_USE_OMTC 1
set -gx MOZ_GLX_IGNORE_BLACKLIST 1

# Java
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# editor
set -gx EDITOR nvim

. ~/.config/fish/aliases.fish
