#/bin/bash
#
SSID=$(wpa_cli status 2>/dev/null | grep -E '^ssid=' | cut -d= -f2)
[ -z "$SSID" ] && SSID="Offline"

ONLINE_STATE=$(networkctl status | grep -w "Online state" | cut -d: -f2 | xargs)
[ -z "$ONLINE_STATE" ] && ONLINE_STATE="unknown"

SIGNAL=$(wpa_cli -i wlan0 signal_poll | grep -E '^AVG_RSSI=' | cut -d= -f2)
[ -z "$SIGNAL" ] && SIGNAL="0"

echo "{\"ssid\":\"$SSID\", \"state\":\"$ONLINE_STATE\", \"signal\":$SIGNAL}"
