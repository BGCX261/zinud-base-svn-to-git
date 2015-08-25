#! /bin/bash
#Ce script est lancé avec votre bureau à la connexion, ajoutez-y tous les programmes que vous souhaitez démarrer avec votre session suivis du symbole: '&'.

#Dossier autostart à utiliser (celui par défaut est le même que gnome et les bureaux compliants freedesktop.org)

Autodir="$HOME/.config/autostart"

# Dossier de config de zinud

Zinrep="$HOME/.config/zinud"

#Son de démarrage

Musique="/usr/share/sounds/zinud/desktop_start.ogg"

if [ -f /usr/bin/ogg123 ] && [ -f $Musique ] ; then ogg123 -q $Musique & 
fi

#Fond'écran

if [ -f /usr/bin/nitrogen ] ; then nitrogen --restore & 
fi

# Le démon de portefeuilles de session

if [ -f /usr/bin/gnome-keyring-daemon ] ; then gnome-keyring-daemon 1>&2 >/dev/null & 
fi

# Activation NumLock

if [ -f /usr/bin/numlockx ] ; then numlockx on & 
fi

# Démon gestionnaire de fichiers (pour montage automatique des volumes si utilisé)

thunar --daemon &

#Démon économiseur d'écran

if [ -f /usr/bin/xscreensaver ] ; then xscreensaver -no-splash & 
fi

# Dossier autostart

if [ -d $Autodir ]
then
	Deskpres=$(ls $Autodir)
	for i in $Deskpres
	do
		Executable=$(cat $Autodir/$i | grep "Exec=" | cut -d "=" -f2)
		$Executable	
	done
fi
if [ -f /usr/bin/conky ]; then conky 2>/dev/null &
fi

# Premier démarrage du bureau

if [ -x $Zinrep/.zinudfirstboot ] 
then $Zinrep/.zinudfirstboot && chmod -x $Zinrep/.zinudfirstboot
fi
exit 0
