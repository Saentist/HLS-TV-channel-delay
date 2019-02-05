#!/bin/bash
/usr/bin/ffmpeg -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 2 -y -nostdin \
-hide_banner -loglevel fatal \
-i http://127.0.0.1:9981/stream/channelnumber/$1 \
-vcodec copy -acodec copy -scodec copy -g 60 \
-fflags +genpts -user_agent HLS_delayer \
-metadata service_provider="TimeShift" \
-metadata service_name="NovaTV +1" \
-f hls -hls_flags delete_segments \
-hls_time 10 \
-hls_list_size 360 \
-hls_wrap 361 \
-hls_segment_filename /disk2/timeshift/$1_%03d.ts /disk2/timeshift/$1_hls.m3u8