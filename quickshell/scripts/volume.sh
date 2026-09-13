#!/bin/bash

VOLUMELEVEL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2 * 100}')
[ -z "$VOLUMELEVEL" ] && VOLUMELEVEL="NFound"

HEADPHONE=$(wpctl status 2>/dev/null| grep -o 'Headphones')
[ -z "$HEADPHONE" ] && HEADPHONE="NFound"

HEADPHONEMUTED=$(wpctl status 2>/dev/null | grep 'Headphones' | grep -o 'MUTED')
[ -z "$HEADPHONEMUTED" ] && HEADPHONEMUTED=""

MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -o 'MUTED')
[ -z "$MUTED" ] && MUTED=""


echo "{\"volume\":\"$VOLUMELEVEL\",\"headphone\":\"$HEADPHONE\",\"headphonemuted\":\"$HEADPHONEMUTED\", \"state\":\"$MUTED\"}"
