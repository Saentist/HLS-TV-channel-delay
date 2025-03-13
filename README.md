# HLS-TV-channel-delay :tv:
###### Solution to make delayed /catchup/ channels with configurable delay time ex. +1h, +6h, +12h +1d etc

as commented in
[https://tvheadend.org](https://tvheadend.org/d/5755-howto-catchup-iptv-a-k-a-1-hour-tv-in-work)

## Service creation

/etc/systemd/system/TV_SERVICE_NAME.service
```ini
[Unit]
Description=HLS Delayer Service for %I
After=network.target

[Service]
Type=simple
ExecStart=/path/to/hls_delayer.sh %i
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

## Enable and start service

```bash
sudo systemctl enable hls_delayer@channel1.service
sudo systemctl start hls_delayer@channel1.service

sudo systemctl enable hls_delayer@channel2.service
sudo systemctl start hls_delayer@channel2.service

# Repeat for other channels as needed
```
## manual start

```
chmod +x hls_delayer.sh
./hls_delayer.sh [channel number]
```

## playlist import script
Imports an M3U playlist, creates and starts services using `hls_delayer.sh`

1. Make the script executable: `chmod +x playlist_import.sh`.
2. Run the script with the M3U playlist file as an argument:
   `./playlist_import.sh /path/to/your_playlist.m3u`

## Webpage
Used for display playlist in browser on any device with support HTML5 with supported A/V codecs

## TO DO

- [ ] optimisation and simplification of usage

1. Integration Plan:
Integrate XMLTV for EPG Support:

2. XMLTV parsing has been partially implemented in hls_delayer.sh.
Include Telemetry for Most-Watched Channels:

3. Telemetry logging is partially implemented in hls_delayer.sh.
Add Timeshift Limit Option:

4. Timeshift limit option is included in hls_delayer.sh.
Use Comskip for Recordings:

5. Add Comskip integration to hls_delayer.sh.
