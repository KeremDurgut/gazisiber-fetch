#!/bin/bash

# Smart Fastfetch Wrapper - Auto-adjusts logo and text based on terminal size
# Created for gazisiber-fetch

# Get terminal dimensions
TERM_COLS=$(tput cols)
TERM_LINES=$(tput lines)

# Configuration paths
CONFIG_DIR="$HOME/.config/fastfetch"
CONFIG_FILE="$CONFIG_DIR/gazisiber_config.jsonc"
LOGO_FILE="$CONFIG_DIR/logo_small.txt"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# Copy files to config directory if not exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -f "$LOGO_FILE" ] && [ -f "$SCRIPT_DIR/logo_small.txt" ]; then
    cp "$SCRIPT_DIR/logo_small.txt" "$LOGO_FILE"
fi
if [ ! -f "$CONFIG_FILE" ] && [ -f "$SCRIPT_DIR/config.jsonc" ]; then
    cp "$SCRIPT_DIR/config.jsonc" "$CONFIG_FILE"
fi

# Calculate dynamic padding based on terminal size
calculate_padding() {
    local cols=$1
    local lines=$2
    
    # Default values for small terminals
    local top=0
    local left=2
    local right=4
    
    # Adjust based on terminal width
    if [ $cols -ge 150 ]; then
        # Very wide terminal - more spacing
        left=4
        right=8
    elif [ $cols -ge 120 ]; then
        # Wide terminal
        left=3
        right=6
    elif [ $cols -ge 100 ]; then
        # Medium-wide terminal
        left=2
        right=5
    elif [ $cols -ge 80 ]; then
        # Standard terminal
        left=2
        right=4
    else
        # Narrow terminal - minimal spacing
        left=1
        right=2
    fi
    
    # Adjust based on terminal height
    if [ $lines -ge 40 ]; then
        top=2
    elif [ $lines -ge 30 ]; then
        top=1
    else
        top=0
    fi
    
    echo "$top $left $right"
}

# Get calculated padding
read TOP_PAD LEFT_PAD RIGHT_PAD <<< $(calculate_padding $TERM_COLS $TERM_LINES)

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    echo "Please run install.sh first or ensure config.jsonc is in the repository directory."
    exit 1
fi

# Create a backup of original config if it doesn't exist
BACKUP_FILE="$CONFIG_DIR/gazisiber_config.jsonc.original"
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_FILE"
fi

# Update the config file with dynamic padding using sed
# This approach modifies the padding values directly in the config
sed -i.tmp "s/\"top\": [0-9]\+/\"top\": $TOP_PAD/g" "$CONFIG_FILE"
sed -i.tmp "s/\"left\": [0-9]\+/\"left\": $LEFT_PAD/g" "$CONFIG_FILE"
sed -i.tmp "s/\"right\": [0-9]\+/\"right\": $RIGHT_PAD/g" "$CONFIG_FILE"

# Clean up sed backup
rm -f "$CONFIG_FILE.tmp"

# Run fastfetch with the updated config
fastfetch --config "$CONFIG_FILE"

# Optional: Restore original config after display (comment out if you want settings to persist)
# cp "$BACKUP_FILE" "$CONFIG_FILE"

