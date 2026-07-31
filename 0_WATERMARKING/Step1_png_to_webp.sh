#!/bin/bash

echo "Starting PNG to WebP conversion..."

# Find all .png files recursively, ignoring hidden files/folders, and convert them
find . -type f ! -name ".*" -name "*.png" -print0 | while IFS= read -r -d '' file; do
    # Remove leading './' for clean output
    clean_path="${file#./}"
    
    # Define output path by replacing the extension with .webp
    output_path="${clean_path%.*}.webp"
    
    echo "Converting: $clean_path ---> $output_path"
    
    # Perform the cwebp conversion at quality 70
    cwebp -q 70 "$file" -o "$output_path" >/dev/null 2>&1
done

echo "------------------------------------------"
echo "Conversion complete! All PNG files have been converted to WebP."