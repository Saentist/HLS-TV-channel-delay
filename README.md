# HLS-TV-channel-delay
###### Solution to make delayed /catchup/ channels with configurable delay time ex. +1h, +6h, +12h +1d etc

as commented in
https://tvheadend.org/boards/4/topics/32005

## Service creation

```
/etc/systemd/system/SERVICE_NAME.service

[Unit]
Description=Timeshift Nova TV
After=tvheadend.service

[Service]
#Type = forking
ExecStart=/home/lib/catch-up/timeshift_ts.sh 103 &

[Install]
WantedBy=default.target
```

## Enable and start service
```
$ sudo systemctl daemon-reload
$ sudo systemctl enable SERVICE_NAME.service # to enable startup exec
$ sudo systemctl start SERVICE_NAME.service
```

## TO DO

- [ ] optimisation and simplification of usage
