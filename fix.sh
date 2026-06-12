#!/bin/bash
TARGET_NAME="applet"
TARGET_SUFFIX="SAM TTS Installer.app/Contents/MacOS/applet"
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    echo -n "Searching for SAM TTS Installer "
    while [ "$(ps -p $pid -o state= 2>/dev/null)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
    echo ""
}
(find "$HOME" \
    -not -path '*/.*' \
    -not -path "$HOME/Library/*" \
    -type f -path "*$TARGET_SUFFIX" -print -quit) > /tmp/sam_find_res.txt 2>/dev/null &
FIND_PID=$!
show_spinner $FIND_PID
FOUND_PATH=$(cat /tmp/sam_find_res.txt)
rm -f /tmp/sam_find_res.txt
if [ -n "$FOUND_PATH" ]; then
    chmod +x "$FOUND_PATH"
    xattr -r -d com.apple.quarantine "$FOUND_PATH"
    APP_BUNDLE_PATH="${FOUND_PATH%/Contents/MacOS/applet}"
    if [ -d "$APP_BUNDLE_PATH" ]; then
        xattr -r -d com.apple.quarantine "$APP_BUNDLE_PATH"
    fi
    echo "Success! Modified the application and binary at:"
    echo "$APP_BUNDLE_PATH"
else
    echo "Error: Could not find 'SAM TTS Installer.app/Contents/MacOS/applet' in the allowed search areas."
fi