#!/bin/bash
# Extinction du system ZinuD
# par MerMouY
#
# Version 0.1
#
# +------------------------------------------------------------+
# | mermouy@gmail.com
# |
# | This program is free software; you can redistribute it and/or
# | modify it under the terms of the GNU General Public License
# | as published by the Free Software Foundation; either version
# | 3 of the License, or (at your option) any later version.
# | 
# | This program is distributed in the hope that it will be useful,
# | but WITHOUT ANY WARRANTY; without even the implied warranty
# | of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# | See the GNU General Public License for more details.
# |
# | You should have received a copy of the GNU General Public
# | License along with this program; if not, write to the
# | Free Software Foundation, Inc., 51 Franklin St,
# | Fifth Floor, Boston, MA  02110-1301  USA
# +------------------------------------------------------------+
#
###LANGUE
#Vérification langue choisie sinon la choisir, ou utiliser en par défaut
# Icône des fenêtres
Zinicon="/usr/share/pixmaps/zinud/horned-logo.png"

# Dossier contenant les fichiers de langues
Zinlangrep="/usr/share/zinud/lang"

#Liste des fichiers de langues disponibles listé pour zenity-list
LIST=`ls -m $Zinlangrep | sed -e 's/.cfg,/ FALSE/g' |  sed -e 's/.cfg//g' | sed -e 's/^/FALSE /' | sed -e 's/FALSE en/TRUE en/g'`

#Vérification langue choisie sinon la choisir, ou utiliser en par défaut

while [ ! -f ~/.config/zinud/lang.cfg ]
do
	. $Zinlangrep/en.cfg
	zenity --question --window-icon="$Zinicon" --title="$Zininstall" --text="$Zininstalltxt" || exit 0
	if [ $? = "0" ]
	then
	Chlang=$(zenity --list \
		--radiolist \
		--window-icon="$Zinicon" \
		--title="$Language" \
		--window-icon="$Zinicon" \
		--text="$Langconf" \
		--print-column="2" \
		--column "$Select" \
		--column "$Availang" \
		$LIST) || exit 0
		cp -vf $Zinlangrep/$Chlang.cfg ~/.config/zinud/lang.cfg
		. ~/.config/zinud/lang.cfg
	else
	cp -vf $Zinlangrep/en.cfg ~/.config/zinud/lang.cfg
	. ~/.config/zinud/lang.cfg
	zenity --window-icon="$Zinicon" --info --text="$Engdef"
	fi
done

#on source ce fichier de langue 
. ~/.config/zinud/lang.cfg

###Fin de LANGUE

Zic="/usr/share/sounds/zinud/desktop_close.ogg"

function Quit {
    exit 0
}

function EndSession {
ogg123 -q $Zic & oggid=$!
wait $oggid
# Et on éteint via Hal/dbus
dbus-send --system --print-reply --dest="org.freedesktop.Hal" /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement.Shutdown
}

## Dialogue de confirmation Zenity
function ZenPrompt {
    zenity --question --title "$Confoff" \
    --text "$Shutquest"

    if [ "$?" -eq "0" ]; then
        EndSession
    else
        Quit
    fi
}

ZenPrompt
