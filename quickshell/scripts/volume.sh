#!/bin/bash

VOLUMELEVEL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2 * 100}')
[ -z "$VOLUMELEVEL" ] && VOLUMELEVEL="NFound"

MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -o 'MUTED')
[ -z "$MUTED" ] && MUTED=""


echo "{\"volume\":\"$VOLUMELEVEL\", \"state\":\"$MUTED\"}"
