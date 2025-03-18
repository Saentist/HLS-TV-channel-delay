#!/bin/bash

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function to suggest installation of a missing command
suggest_install() {
    echo "Dependency '$1' is missing. Please install it using the following command:"
    echo "sudo apt-get install $1"
}

# Check for FFmpeg
if check_command ffmpeg; then
    echo "FFmpeg is installed."
else
    suggest_install ffmpeg
fi

# Check for Comskip
if check_command comskip; then
    echo "Comskip is installed."
else
    suggest_install comskip
fi

# Check for Bash (usually installed by default)
if check_command bash; then
    echo "Bash is installed."
else
    echo "Bash is not installed. It is usually included by default in most systems."
fi

echo "Dependency check completed."
