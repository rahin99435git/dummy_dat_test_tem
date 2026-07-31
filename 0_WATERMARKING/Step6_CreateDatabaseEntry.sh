#!/bin/bash

OUTPUT_FILE="file_list.txt"

# Clear or create the output file at the start
> "$OUTPUT_FILE"

# Loop through each directory in the current folder
find . -mindepth 1 -maxdepth 1 -type d | while IFS= read -r dir; do
    raw_folder_name=$(basename "$dir")
    
    # 1. Remove the underscore from the folder name
    clean_name="${raw_folder_name//_/}"
    
    # 2. Reverse the transformation done in Step 5 (move the last letter back to the front)
    if [ -n "$clean_name" ]; then
        last_char="${clean_name: -1}"
        front_chars="${clean_name%?}"
        folder_name="${last_char}${front_chars}"
    else
        folder_name="$clean_name"
    fi
    
    # Write the transformed folder name with a colon as the group header
    echo "${folder_name}:" >> "$OUTPUT_FILE"
    
    # Find all valid files inside this specific directory (excluding .DS_Store)
    find "$dir" -type f ! -name ".DS_Store" | while IFS= read -r file; do
        # Remove the leading './' from the path
        clean_path="${file#./}"
        
        # Format and append with the 'image: ' prefix under the group header
        echo "image: 'https://raw.githubusercontent.com/rahin99435git/dummy_dat_test_tem/main/${clean_path}'," >> "$OUTPUT_FILE"
    done
done

echo "Done! Grouped file list saved to $OUTPUT_FILE"