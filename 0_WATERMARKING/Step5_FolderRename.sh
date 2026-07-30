#!/bin/bash

# Find all directories in the current folder (excluding the root '.')
find . -mindepth 1 -maxdepth 1 -type d | while IFS= read -r dir; do
    base_name=$(basename "$dir")
    parent_dir=$(dirname "$dir")
    
    # Take the first letter and put it at the end, then append an underscore
    first_char="${base_name:0:1}"
    rest_chars="${base_name:1}"
    new_name="${rest_chars}${first_char}_"
    
    # Rename the folder
    mv "$dir" "$parent_dir/$new_name"
    echo "Renamed: '$base_name' ---> '$new_name'"
done

echo "Done renaming all folders!"