#!/bin/bash

# Variables
M3U_PLAYLIST=$1
OUTPUT_M3U_PLAYLIST="/path/to/output_playlist.m3u"
SERVICE_NAME_TEMPLATE="hls_delayer@channel"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Check if the M3U playlist file exists
if [ ! -f "$M3U_PLAYLIST" ]; then
    log "ERROR: M3U playlist file $M3U_PLAYLIST does not exist."
    exit 1
fi

# Create output M3U playlist file
echo "#EXTM3U" > "$OUTPUT_M3U_PLAYLIST"

# Read M3U playlist and start services
CHANNEL_INDEX=1
while IFS= read -r line; do
    # Skip comments and empty lines
    if [[ "$line" =~ ^# ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    CHANNEL_URL=$line
    SERVICE_NAME="${SERVICE_NAME_TEMPLATE}${CHANNEL_INDEX}.service"
    
    # Create service file
    cat <<EOF > "/etc/systemd/system/$SERVICE_NAME"
[Unit]
Description=HLS Delayer Service for Channel $CHANNEL_INDEX
After=network.target

[Service]
Type=simple
ExecStart=/path/to/hls_delayer.sh "$CHANNEL_URL"
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    
    # Enable and start the service
    sudo systemctl enable "$SERVICE_NAME"
    sudo systemctl start "$SERVICE_NAME"
    
    # Add entry to output M3U playlist
    echo "#EXTINF:-1,Channel $CHANNEL_INDEX" >> "$OUTPUT_M3U_PLAYLIST"
    echo "$CHANNEL_URL" >> "$OUTPUT_M3U_PLAYLIST"
    
    log "Started service for channel $CHANNEL_INDEX with URL $CHANNEL_URL"
    ((CHANNEL_INDEX++))
done < "$M3U_PLAYLIST"

log "All services started successfully and output M3U playlist created at $OUTPUT_M3U_PLAYLIST."
