 
#!/bin/bash

# Demander le lien Spotify
url=$(zenity --entry --title="Télécharger une musique" --text="Entrez l'URL Spotify :")

if [[ -z "$url" ]]; then
    zenity --error --text="Aucune URL fournie."
    exit 1
fi

# Télécharger avec spotDL
spotdl "$url" -o ~/Téléchargements

zenity --info --text="Téléchargement terminé."
