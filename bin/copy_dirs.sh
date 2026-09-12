#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="$2"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory does not exist!"
    exit 1
fi

# Check if destination directory exists
if [ ! -d "$DEST_DIR" ]; then
    echo "Destination directory does not exist!"
    exit 1
fi

# Loop through all files in the source directory
for src_file in "$SOURCE_DIR"/*; do
    echo "Processing $src_file"
    # Get the filename
    filename=$(basename "$src_file")
    dest_file="$DEST_DIR/$filename"

    # If a file with the same name exists in the destination directory
    if [ -e "$dest_file" ]; then
        # Extract the name and extension
        base_name="${filename%.*}"
        extension="${filename##*.}"

        # Initialize counter
        counter=1

        # Generate new filename with counter
        while [ -e "$DEST_DIR/${base_name}_$counter.$extension" ]; do
            counter=$((counter + 1))
        done

        # Set the new filename
        dest_file="$DEST_DIR/${base_name}_$counter.$extension"
    fi

    # Copy the file
    cp "$src_file" "$dest_file"
done

echo "Files copied successfully!"

