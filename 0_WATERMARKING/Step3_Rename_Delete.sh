#!/bin/bash

LOG_FILE="FOLDERSCLEANED.txt"
last_dir=""

# 1. Find all files ending in _wm.webp
find . -name "*_wm.webp" -print0 | while read -r -d '' wm_file; do
    
    # 2. Determine the original filename (removing the _wm part)
    # This turns "image_wm.webp" into "image.webp"
    original_file="${wm_file%_wm.webp}.webp"
    
    # 3. Handle folder logging
    current_dir=$(dirname "$wm_file")
    if [ "$current_dir" != "$last_dir" ]; then
        folder_name=$(basename "$current_dir")
        echo "Cleaning up folder: $folder_name"
        echo "$folder_name" >> "$LOG_FILE"
        last_dir="$current_dir"
    fi

    # 4. Perform the swap
    if [ -f "$original_file" ]; then
        # Remove the original and rename the watermarked one
        rm "$original_file"
        mv "$wm_file" "$original_file"
    else
        # If the original isn't there, just rename the wm file
        mv "$wm_file" "$original_file"
    fi

done

echo "------------------------------------------"
echo "Cleanup complete. Original files replaced."
echo "Processed folders listed in $LOG_FILE"