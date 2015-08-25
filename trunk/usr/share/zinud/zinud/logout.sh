#!/bin/bash
# Fermeture de la session ZinuD
# par MerMouY
procall=`pgrep -u $(whoami) -t tty1`        #Récupère tous les processus
procbas=`pgrep -u $(whoami) -t tty1 bash`    #Récupère le bash id
procxin=`pgrep -u $(whoami) -t tty1 xinit`    #Récupère de pid de xinit
Zic="/usr/share/sounds/zinud/desktop_close.ogg"

## Fermeture propre de la session
function EndSession {
ogg123 -q $Zic & oggid=$!
wait $oggid
# Termine proprement tous les processus sauf xinit et bash
	for p in $procall; do
    if [ "$p" != "$procbas" ] && [ "$p" != "$procxin" ]; then
        kill -TERM $p
    fi
done
sleep 2

# On tue les processus encore en vie
for p in $procall; do
        kill -KILL $p
done
sync
exit
}


## Dialogue de confirmation zenity
function ZenPrompt {
    zenity --question --title "Confirmation déconnecter" \
    --text "Êtes vous sûr de vouloir vous déconnecter?"

    if [ "$?" -eq "0" ]; then
        EndSession
    else
        exit
    fi
}

ZenPrompt
