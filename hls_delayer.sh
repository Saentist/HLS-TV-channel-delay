#!/bin/bash

# Variables for configuration
INPUT_URL="http://127.0.0.1:9981/stream/channelnumber/$1"
OUTPUT_DIR="/disk2/timeshift"
SEGMENT_FILENAME="$OUTPUT_DIR/$1_%03d.ts"
PLAYLIST_FILENAME="$OUTPUT_DIR/$1_hls.m3u8"
LOG_LEVEL="fatal"
USER_AGENT="HLS_delayer"
SERVICE_PROVIDER="TimeShift"
SERVICE_NAME="NovaTV +1"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Check if the output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    log "ERROR: Output directory $OUTPUT_DIR does not exist."
    exit 1
fi

log "Starting HLS delayer for channel $1"

# Execute ffmpeg with error handling
/usr/bin/ffmpeg -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 2 -y -nostdin \
-hide_banner -loglevel $LOG_LEVEL \
-i $INPUT_URL \
-vcodec copy -acodec copy -scodec copy -g 60 \
-fflags +genpts -user_agent $USER_AGENT \
-metadata service_provider="$SERVICE_PROVIDER" \
-metadata service_name="$SERVICE_NAME" \
-f hls -hls_flags delete_segments \
-hls_time 10 \
-hls_list_size 360 \
-hls_wrap 361 \
-hls_segment_filename $SEGMENT_FILENAME $PLAYLIST_FILENAME

if [ $? -ne 0 ]; then
    log "ERROR: ffmpeg encountered an error."
    exit 1
fi

log "HLS delayer for channel $1 completed successfully"
