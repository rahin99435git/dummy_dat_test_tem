#!/bin/bash

OUTPUT_FILE="file_list.txt"

# Clear or create the output file at the start
> "$OUTPUT_FILE"

# Find files inside any subfolder, excluding .DS_Store files automatically
find . -mindepth 2 -type f ! -name ".DS_Store" | while IFS= read -r file; do
    # Remove the leading './' from the path
    clean_path="${file#./}"
    
    # Format and append to the output file for every folder and file combination
    echo "https://raw.githubusercontent.com/rahin99435git/dummy_dat_test_tem/main/${clean_path}'," >> "$OUTPUT_FILE"
done

echo "Done! All folder and file combinations saved to $OUTPUT_FILE"