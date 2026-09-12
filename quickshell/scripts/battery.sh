#!/bin/bash
CAPACITY=$(cat "/sys/class/power_supply/BAT1/capacity")
[ -z "$CAPACITY" ] && CAPACITY="NFound"

STATE=$(cat "/sys/class/power_supply/BAT1/status")
[ -z "$STATUS" ] && STATUS="NFound"


echo "{\"capacity\":\"$CAPACITY\", \"state\":\"$STATE\"}"
