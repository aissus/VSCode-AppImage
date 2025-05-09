#!/bin/bash

# Define variables
DESTINATION="$HOME/Downloads/VSCode-x86_64.AppImage"
TEMP_FILE="$(mktemp)"

# Define repositories
REPO1="valicm/VSCode-AppImage"
REPO2="aissus/VSCode-AppImage"

# Fetch latest release dates
DATE1=$(curl -s "https://api.github.com/repos/$REPO1/releases/latest" | grep '"published_at":' | cut -d '"' -f4)
DATE2=$(curl -s "https://api.github.com/repos/$REPO2/releases/latest" | grep '"published_at":' | cut -d '"' -f4)

# Convert to Unix timestamps
TIME1=$(date -d "$DATE1" +%s)
TIME2=$(date -d "$DATE2" +%s)

# Pick the newer one
if [ "$TIME1" -gt "$TIME2" ]; then
    DOWNLOAD_URL="https://github.com/$REPO1/releases/download/latest/VSCode-x86_64.AppImage"
else
    DOWNLOAD_URL="https://github.com/$REPO2/releases/download/latest/VSCode-x86_64.AppImage"
fi

# Download the AppImage
echo "Downloading VSCode AppImage from: $DOWNLOAD_URL"
if curl -L -o "$TEMP_FILE" "$DOWNLOAD_URL"; then
    mv "$TEMP_FILE" "$DESTINATION"
    chmod +x "$DESTINATION"
    echo "VSCode AppImage updated successfully!"
else
    echo "Download failed. Please check the URL or your internet connection."
    rm -f "$TEMP_FILE"
    exit 1
fi
