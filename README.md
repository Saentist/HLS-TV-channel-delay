# HLS-TV-channel-delay :tv:
###### Solution to make delayed /catchup/ channels with configurable delay time ex. +1h, +6h, +12h +1d etc

as commented in
[https://tvheadend.org](https://tvheadend.org/d/5755-howto-catchup-iptv-a-k-a-1-hour-tv-in-work)

## Service creation

/etc/systemd/system/TV_SERVICE_NAME.service
```
[Unit]
Description=Timeshift TV_SERVICE_NAME
After=tvheadend.service

[Service]
#Type = forking
ExecStart=/home/hts/hls_delayer.sh 103 &

[Install]
WantedBy=default.target
```

## Enable and start service
```
$ sudo systemctl daemon-reload
$ sudo systemctl enable TV_SERVICE_NAME.service # to enable startup exec
$ sudo systemctl start TV_SERVICE_NAME.service
```
## manual start

```
chmod +x hls_delayer.sh
./hls_delayer.sh [channel number]
```


1. Make the script executable: `chmod +x playlist_import.sh`.
2. Run the script with the M3U playlist file as an argument:
   `./playlist_import.sh /path/to/your_playlist.m3u`

## TO DO

- [ ] optimisation and simplification of usage
