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
EPG_FILE="/path/to/your_epg.xml"
TELEMETRY_FILE="/path/to/telemetry.log"
MAX_TIMESHIFT_HOURS=24  # Maximum timeshift duration in hours

# Default delay time in seconds (e.g., 1 hour)
DEFAULT_DELAY_SECONDS=3600

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to update telemetry
update_telemetry() {
    local channel=$1
    echo "$channel" >> "$TELEMETRY_FILE"
}

# Function to parse XMLTV for EPG
parse_epg() {
    local channel_name=$1
    local epg_info=$(grep -A 5 "<channel id=\"$channel_name\">" "$EPG_FILE")
    echo "$epg_info"
}

# Function to run Comskip
run_comskip() {
    local video_file=$1
    /usr/local/bin/comskip "$video_file"
}

# Function to calculate delay time
calculate_delay() {
    local delay_hours=$1
    echo $((delay_hours * 3600))
}

# Check if the output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    log "ERROR: Output directory $OUTPUT_DIR does not exist."
    exit 1
fi

# Check if a delay time is provided
if [ -n "$2" ]; then
    DELAY_SECONDS=$(calculate_delay "$2")
else
    DELAY_SECONDS=$DEFAULT_DELAY_SECONDS
fi

log "Starting HLS delayer for channel $1 with delay of $DELAY_SECONDS seconds"

# Update telemetry
update_telemetry "$SERVICE_NAME"

# Fetch EPG info
epg_info=$(parse_epg "$SERVICE_NAME")
log "EPG Info: $epg_info"

# Calculate the maximum number of segments based on the timeshift limit
HLS_LIST_SIZE=$((MAX_TIMESHIFT_HOURS * 3600 / 10))

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
-hls_list_size $HLS_LIST_SIZE \
-hls_wrap $((HLS_LIST_SIZE + 1)) \
-hls_segment_filename $SEGMENT_FILENAME $PLAYLIST_FILENAME

if [ $? -ne 0 ]; then
    log "ERROR: ffmpeg encountered an error."
    exit 1
fi

# Run Comskip on the recorded segments
for segment in $(ls $OUTPUT_DIR/*.ts); do
    run_comskip "$segment"
done

log "HLS delayer for channel $1 completed successfully"
