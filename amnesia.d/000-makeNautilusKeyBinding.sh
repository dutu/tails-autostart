#!/bin/bash

# Turn off gnome terminal system colors
cat << EOF | dconf load /org/gnome/settings-daemon/plugins/media-keys/
[/]
custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']
screensaver=''

[custom-keybindings/custom3]
binding='<Super>w'
command='tor-browser'
name='Open Tor Browser'

[custom-keybindings/custom2]
binding='<Super>t'
command='gnome-terminal'
name='Open Terminal'

[custom-keybindings/custom1]
binding='<Super>e'
command='nautilus'
name='Open File Browser'

[custom-keybindings/custom0]
binding='<Super>l'
command='tails-screen-locker'
name='Lock Screen'
EOF
