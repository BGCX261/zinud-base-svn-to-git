 #! /bin/bash

# Le démon dbus

if which dbus-launch > /dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
eval `dbus-launch --sh-syntax --exit-with-session`
fi

# La session compiz-fusion

if [ -e /usr/bin/fusion-icon ]
	then fusion-icon & compid=$! &
else compiz-manager & compid=$! &
fi
sleep 2
# La barre des tâches/lanceurs d'applications

cairo-dock -o &
sleep 2
# Les applications perso de l'utilisateur

~/.config/zinud/autostart.sh 2>$HOME/.config/zinud/autostart.log &

# Attendre compiz pour fermer

wait $compid
