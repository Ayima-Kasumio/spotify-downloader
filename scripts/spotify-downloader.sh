 #!/bin/bash

# Fonction pour afficher le menu principal
afficher_menu() {
    action=$(zenity --list \
        --title="Spotify Downloader" \
        --text="Que voulez-vous faire ?" \
        --column="Actions" \
        "Télécharger une musique" \
        "Organiser les fichiers musicaux" \
        "Quitter")

    case $action in
        "Télécharger une musique")
            telecharger_musique
            ;;
        "Organiser les fichiers musicaux")
            organiser_fichiers
            ;;
        "Quitter")
            exit 0
            ;;
        *)
            zenity --error --text="Action non reconnue."
            ;;
    esac
}

# Fonction pour télécharger une musique
telecharger_musique() {
    # Demander l'URL Spotify
    url=$(zenity --entry --title="Télécharger une musique" --text="Entrez l'URL Spotify :")

    if [[ -z "$url" ]]; then
        zenity --error --text="Aucune URL fournie."
        return
    fi

    # Demander le dossier de téléchargement
    dossier=$(zenity --file-selection --directory --title="Sélectionnez le dossier de téléchargement")

    if [[ -z "$dossier" ]]; then
        zenity --error --text="Aucun dossier sélectionné."
        return
    fi

    # Exécuter le téléchargement
    (spotdl "$url" -o "$dossier" &> "$dossier/log_spotdl.txt" && \
    zenity --info --text="Téléchargement terminé.") || \
    zenity --error --text="Erreur lors du téléchargement."
}

# Fonction pour organiser les fichiers musicaux
organiser_fichiers() {
    # Demander le dossier source
    dossier_musique=$(zenity --file-selection --directory --title="Sélectionnez le dossier contenant les fichiers musicaux")

    if [[ -z "$dossier_musique" ]]; then
        zenity --error --text="Aucun dossier sélectionné."
        return
    fi

    # Demander le dossier de destination
    dossier_destination=$(zenity --file-selection --directory --title="Sélectionnez le dossier où organiser les fichiers")

    if [[ -z "$dossier_destination" ]]; then
        zenity --error --text="Aucun dossier de destination sélectionné."
        return
    fi

    # Parcourir et organiser les fichiers
    find "$dossier_musique" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.aac" -o -iname "*.ogg" \) | while read -r music_file; do
        # Obtenir les métadonnées de l'artiste
        artist=$(ffprobe -v quiet -show_entries format_tags=artist -of default=nw=1:nk=1 "$music_file" 2>/dev/null)

        # Si l'artiste est vide, on utilise "Inconnu"
        if [ -z "$artist" ]; then
            artist="Inconnu"
        fi

        # Crée un dossier pour l'artiste dans le dossier de destination
        artist_dir="$dossier_destination/$artist"
        mkdir -p "$artist_dir"

        # Vérifie si le fichier est déjà bien placé
        if [ "$artist_dir/$(basename "$music_file")" != "$music_file" ]; then
            # Déplace la musique dans le dossier correspondant
            mv "$music_file" "$artist_dir/"
            echo "Déplacé : $music_file -> $artist_dir"
        fi
    done

    zenity --info --text="Organisation terminée."
}

# Lancer le menu principal
afficher_menu
