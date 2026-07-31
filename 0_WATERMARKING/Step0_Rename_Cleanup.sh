#!/bin/bash

# Get the name of the script itself to skip it
script_name=$(basename "$0")

echo "Starting recursive file renaming..."

# Find all files recursively in current directory and subfolders
find . -type f | while IFS= read -r old_path; do
    filename=$(basename "$old_path")
    folder_path=$(dirname "$old_path")
    
    # Skip the script itself so it doesn't rename itself
    if [ "$filename" = "$script_name" ]; then
        continue
    fi
    
    # Separate file extension from filename
    ext="${filename##*.}"
    name="${filename%.*}"
    
    # If the file has no extension (e.g., hidden files or plain names)
    if [ "$filename" = "$ext" ]; then
        ext=""
        name="$filename"
    else
        ext=".$ext"
    fi
    
    # Clean name: keep only alphanumeric characters, replace everything else with spaces
    # Then squash multiple spaces and trim whitespace
    cleaned_chars=$(echo "$name" | LC_ALL=C sed 's/[^[:alnum:]]/ /g')
    read -r -a words <<< "$cleaned_chars"
    
    # If no valid alphanumeric characters exist, skip
    if [ ${#words[@]} -eq 0 ]; then
        continue
    fi
    
    # Keep up to 3 words max and join them together
    base_new_name="${words[0]}${words[1]}${words[2]}"
    
    # Enforce 18 characters max limit on the base name
    if [ ${#base_new_name} -gt 18 ]; then
        base_new_name="${base_new_name:0:18}"
    fi
    
    # Generate a random version suffix between 1 and 99
    version_num=$((1 + RANDOM % 99))
    version_str="_v${version_num}"
    
    # Construct new filename and path
    new_filename="${base_new_name}${version_str}${ext}"
    new_path="$folder_path/$new_filename"
    
    # Rename the file
    if mv "$old_path" "$new_path"; then
        rel_path="${folder_path#./}"
        echo "Renamed: '$filename' ---> '$new_filename' (in $rel_path)"
    else
        echo "Failed to rename '$filename'"
    fi
done

echo "------------------------------------------"
echo "Done renaming files!"