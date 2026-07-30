#!/bin/bash

# Define the log file
LOG_FILE="FOLDERSDONE.txt"

# Clear or create the log file at the start (optional)
# Remove the '#' below if you want a fresh list every time you run the script
# > "$LOG_FILE"

last_dir=""

# Using -print0 to handle spaces in filenames safely
find . -name "*.webp" -not -path "./FinalLogo.webp" -not -path "./$LOG_FILE" -print0 | while read -r -d '' file; do
    
    # Get the directory path
    current_dir=$(dirname "$file")
    
    # If we enter a new directory, log it and echo it
    if [ "$current_dir" != "$last_dir" ]; then
        folder_name=$(basename "$current_dir")
        
        echo "Processing: $folder_name"
        echo "$folder_name" >> "$LOG_FILE"
        
        last_dir="$current_dir"
    fi

    # ImageMagick logic
    width=$(magick "$file" -format "%w" info:)
    height=$(magick "$file" -format "%h" info:)
    
    x=$((width*10/100))
    y=$((height*20/100))
    
    magick "$file" \( FinalLogo.webp -alpha set -channel A -evaluate Multiply 0.20 +channel \) \
    -gravity southwest -geometry "+${x}+${y}" -compose over -composite "${file%.*}_wm.webp"

done

echo "------------------------------------------"
echo "Done! Check $LOG_FILE for the full list."