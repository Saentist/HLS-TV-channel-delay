# HLS-TV-channel-delay :tv:
###### Solution to make delayed /catchup/ channels with configurable delay time ex. +1h, +6h, +12h +1d etc

as commented in
https://tvheadend.org/boards/4/topics/32005

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

## TO DO

- [ ] optimisation and simplification of usage
