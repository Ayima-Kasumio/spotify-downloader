 
#!/bin/bash

# Interface graphique pour le menu principal
action=$(zenity --list \
    --title="Spotify Downloader" \
    --column="Action" \
    "Télécharger des musiques" \
    "Organiser les fichiers" \
    "Quitter")

case $action in
    "Télécharger des musiques")
        ./scripts/download.sh
        ;;
    "Organiser les fichiers")
        ./scripts/organize.sh
        ;;
    "Quitter")
        exit 0
        ;;
    *)
        zenity --error --text="Action non reconnue."
        ;;
esac
