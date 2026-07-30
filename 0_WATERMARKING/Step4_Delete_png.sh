#!/bin/bash

# Find and delete all .png files recursively in current folder and subfolders
find . -type f -name "*.png" -delete

echo "All .png files have been deleted."