#!/bin/bash

# Chemin des fichiers à organiser
source_dir=$(zenity --file-selection --directory --title="Sélectionnez le dossier source")

# Organisation par artiste
if [[ -z "$source_dir" ]]; then
    zenity --error --text="Aucun dossier sélectionné."
    exit 1
fi

for file in "$source_dir"/*.mp3; do
    artist=$(ffprobe -v quiet -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")
    mkdir -p "$source_dir/$artist"
    mv "$file" "$source_dir/$artist"
done

zenity --info --text="Organisation terminée."
 
