#!/bin/bash

# Update system
echo "Updating your system"
sudo pacman -Syu --noconfirm

clear
echo "System uploaded"


REPO=$HOME/bspwm-dotfile

# Making the directories

#mkdir -p ~/.config/bspwm
#mkdir -p ~/.config/sxhkd
#mkdir -p ~/.config/picom
#mkdir -p ~/.config/polybar
#mkdir -p ~/.config/kitty
#mkdir -p ~/.config/rofi

# install the dependencies
#source dependencies.conf

#for dpn in ${DEPENDENCIES[@]}; do
#	sudo pacman -Sy --noconfirm ${dpn}
#done

clear
echo "Dependencies installed"

# Create the files
echo "Creating files in ~/bspwm-dotfiles"

#bspwm
mkdir -p $REPO/bspwm
cat <<EOF > $REPO/bspwm/bspwmrc
#! /bin/sh

pgrep -x sxhkd > /dev/null || sxhkd &

bspc monitor -d I II III IV V VI VII VIII IX X

bspc config border_width         2
bspc config window_gap          12

bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off

xrandr -s 1920x1080
setxkbmap -layout latam
feh --bg-scale ~/Imagenes/fondo.png
sh ~/.config/polybar/launch.sh
picom --conf ~/.config/picom/picom.conf
EOF

echo "bspwrc file created successfully"

# Making the bspwrc executable
chmod +x $REPO/bspwm/bspwmrc

# sxhdrc
mkdir -p $REPO/sxhkd
echo "Creating sxhkdrc in $REPO/sxhkd"
cat << EOF > $REPO/sxhkd/sxhkdrc
#
# wm independent hotkeys
#

# terminal emulator
super + Return
	kitty

# program launcher
super + d
	rofi -show drun

# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd

#
# bspwm hotkeys
#

# quit/restart bspwm
super + alt + {q,r}
	bspc {quit,wm -r}

# close and kill
super + {_,shift + }w
	bspc node -{c,k}

# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next

# send the newest marked node to the newest preselected node
super + y
	bspc node newest.marked.local -n newest.!automatic.local

# swap the current node and the biggest window
super + g
	bspc node -s biggest.window

#
# state/flags
#

# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# set the node flags
super + ctrl + {m,x,y,z}
	bspc node -g {marked,locked,sticky,private}

#
# focus/swap
#

# focus the node in the given direction
super + alt + {Left,Down,Up,Right}
	bspc node -{f,s} {west,south,north,east}

# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}

# focus the next/previous window in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local.!hidden.window

# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local

# focus the last node/desktop
super + {grave,Tab}
	bspc {node,desktop} -f last

# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \
	bspc node {older,newer} -f; \
	bspc wm -h on

# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

#
# preselect
#

# preselect the direction
super + ctrl + {Left,Down,Up,Right}
	bspc node -p {west,south,north,east}

# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}

# cancel the preselection for the focused node
super + ctrl + space
	bspc node -p cancel

# cancel the preselection for the focused desktop
super + ctrl + shift + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

#
# move/resize
#

# expand a window by moving one of its side outward
super + ctrl + alt + {Left,Down,Up,Right}
	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# contract a window by moving one of its side inward
super + alt + shift + {Left,Down,Up,Right}
	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# move a floating window
super + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}

# firefox
super + shift + f
	firefox

# Volume
XF86AudioRaiseVolume
	pamixer -i 5

XF86AudioLowerVolume
	pamixer -d 5

XF86AudioMute
	pamixer -t

# Brillo
XF86MonBrightnessUp
	brightnessctl set +5%

XF86MonBrightnessDown
	brightnessctl set 5%-
EOF
echo "sxhkdrc file created successfully"

# picom
mkdir -p $REPO/picom
echo "Creating picom.conf in $REPO/picom"
cat <<EOF > $REPO/picom/picom.conf
# General
backend = "xrender";
vsync = false;

# Fading
fading = true;
fade-in-step = 0.05;
fade-out-step = 0.05;

# Opacidad
inactive-opacity = 0.8;
active-opacity = 1.0;
frame-opacity = 0.9;
EOF

echo "picom.conf created successfully"

# Polybar
# launch.sh
echo "Creating polybar files"
echo "Creating launch file in $REPO/polybar"

mkdir -p $REPO/polybar
cat <<EOF > $REPO/polybar/launch.sh
#!/usr/bin/env sh
# Terminar instancias previas de la Polybar
killall -q polybar

# Esperar hasta que todos los procesos de Polybar hayan sido terminados
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Iniciar Polybar
polybar example &
EOF

echo "launch.sh created successfully"
chmod +x $REPO/polybar/launch.sh

# config.ini
echo "Creating config.ini in $REPO/polybar"
cat <<'EOF' > $REPO/polybar/config.ini
[colors]
background = ${xrdb:color0:#2E3440}
foreground = ${xrdb:color7:#FFFFFF}
primary = ${xrdb:color1:#FF69B4}
secondary = ${xrdb:color2:#FF1493}
urgent = #FF0000
empty = #888888
white = #FFFFFF

[bar/example]
width = 98.7%
height = 30
offset-x = 0.7%
offset-y = 1%
background = ${colors.background}
foreground = ${colors.foreground}
font-0 = "Hack Nerd Font:size=10;2"

modules-left = spacer battery bspwm_spacer network bspwm_spacer volume
modules-center = bspwm_spacer bspwm
modules-right = date

[module/date]
type = internal/date
interval = 1
date = %{F#FF69B4}Fecha:%{F-} %{F#FFFFFF}%Y-%m-%d%{F-} %{F#FF69B4}Hora:%{F-} %{F#FFFFFF}%H:%M:%S%{F-}
label = %date%
label-padding = 1
label-margin-right = 1

[module/spacer]
type = custom/text
content = " "
content-padding = 0

[module/bspwm_spacer]
type = custom/text
content = " "
content-padding = 1

[module/bspwm]
type = internal/bspwm
pin-workspaces = true
enable-click = true
enable-scroll = true
font-0 = "Material Icons:style=Regular"
font-1 = "FontAwesome5Free:style=Solid:pixelsize=10:antialias=false;3"
font-2 = "FontAwesome5Brands:style=Solid:pixelsize=10:antialias=false;3"

ws-icon-0 = 0;•
ws-icon-1 = 1;•
ws-icon-2 = 2;•
ws-icon-3 = 3;•
ws-icon-4 = 4;•
ws-icon-5 = 5;•
ws-icon-6 = 6;•
ws-icon-7 = 7;•
ws-icon-8 = 8;•
ws-icon-9 = 9;•

format = <label-state>
format-padding = 0


label-focused = "•  "
label-focused-foreground = ${colors.primary}
label-focused-background = ${colors.background}

label-occupied = "•  "
label-ocuppied-foreground = ${colors.secondary}
label-ocuppied-background = ${colors.background}

label-urgent = "•  "
label-urgent-foreground = ${colors.urgent}
label-urgent-background = ${colors.background}

label-empty = "•  "
label-empty-foreground = ${colors.empty}
label-empty-background = ${colors.background}

[module/battery]
type = internal/battery
battery = BAT1
adapter = ACAD
full-at = 99
time-format = %H:%M
poll-interval = 2
offset-x = 1%
format-charging = <animation-charging> <label-charging>
label-charging = %{F#FF69B4}%{F-} %percentage%% %{F#FFFFFF}%time%%{F-}

format-discharging = <ramp-capacity> <label-discharging>
label-discharging = %{F#FFFFFF}%percentage%% %{F#FF69B4}%time%%{F-}

format-full = <label-full>
format-full-prefix = " "
format-full-prefix-foreground = #666

ramp-capacity-0 = ""
ramp-capacity-1 = ""
ramp-capacity-2 = ""
ramp-capacity-3 = ""
ramp-capacity-4 = ""
ramp-capacity-foreground = #FFFFFF

animation-charging-0 = ""
animation-charging-1 = ""
animation-charging-2 = ""
animation-charging-foreground = #FF69B4
animation-charging-framerate = 750

font-0 = "Hack Nerd Font:size=10;2"
label-padding = 2
label-margin-left = 2

[module/network]
type = custom/script
exec = /home/gael/.config/polybar/scripts/network-status.sh
interval = 10

[module/volume]
type = internal/alsa
format-volume = <ramp-volume> <label-volume>
format-muted = <label-muted>
label-volume = %percentage%%
label-muted = %{F#FF69B4}󰸈 Mute%{F-}
font-0 = "Hack Nerd Font size=10;2"

ramp-volume-0 = 󰕿
ramp-volume-1 = 󰖀
ramp-volume-2 = 󰕾
ramp-volume-mute = "󰸈 "
ramp-volume-foreground = #FFFFFF%
EOF

echo "config.ini created successfully"

# Network status
mkdir -p $REPO/polybar/scripts
cat <<'EOF' > $REPO/polybar/scripts/network-status.sh
#!/bin/bash

# Obtiene el nombre de la interfaz de red activa
interface=$(ip route | awk '/default/ { print $5 ; exit }')

if [ "$interface" = "ens33" ]; then
	# Para la conexión a Ethernet
	ip_address=$(ip -4 -o addr show ens33 | awk '{print $4}' | cut -d/ -f1)
	echo "%{F#FFFFFF}󰈀 $ip_address"
elif [ "$interface" = "lo" ]; then
	# Para la conexión Wi-Fi
	ssid=$(nmcli -t -f active,ssid dev wifi | grep '^sí' | cut -d':' -f2)
	echo "%{F#FFFFFF}  $ssid"
else
	# Sin conexión
	echo "%{F#FF0000}Desconectado"
fi
EOF

chmod +x $REPO/polybar/scripts/network-status.sh

# Rofi theme
mkdir $REPO/rofi/themes
wget -O $REPO/rofi/themes/rounded-common.rasi https://raw.githubusercontent.com/newmanls/rofi-themes-collection/refs/heads/master/themes/template/rounded-template.rasi
wget -O $REPO/rofi/themes/rounded-pink-dark.rasi https://raw.githubusercontent.com/newmanls/rofi-themes-collection/refs/heads/master/themes/rounded-pink-dark.rasi
echo "To install select the rofi theme please make rofi-theme-selector and chose rounded-pink-dark"

# Symlink
ln -sf $REPO/bspwm/bspwmrc $HOME/.config/bspwm/bspwmrc
ln -sf $REPO/sxhkd/sxhkdrc $HOME/.config/sxhkd/sxhkdrc
ln -sf $REPO/picom/picom.conf $HOME/.config/picom/picom.conf
ln -sf $REPO/polybar/config.ini $HOME/.config/polybar/config.ini
ln -sf $REPO/polybar/launch.sh $HOME/.config/polybar/launch.sh
ln -sf $REPO/polybar/scripts/network-status.sh $HOME/.config/polybar/scripts/network-status.sh
ln -sf $REPO/rofi/themes/rounded-template.rasi $HOME/.config/rofi/themes/rounded-template.rasi
ln -sf $REPO/rofi/themes/rounded-pink-dark.rasi $HOME/.config/rofi/themes/rounded-template.rasi
