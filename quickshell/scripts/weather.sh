#!/bin/bash

WEATHER=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=25.59&longitude=85.14&current=temperature_2m,weather_code")

TEMPERATURE=$(echo "$WEATHER" | jq -r '.current.temperature_2m')
WEATHERCODE=$(echo "$WEATHER" | jq -r '.current.weather_code')

[ -z "$TEMPERATURE" ] && TEMPERATURE="NFound"
[ -z "$WEATHERCODE" ] && WEATHERCODE="NFound"

echo "{\"temperature\":\"$TEMPERATURE\",\"weathercode\":\"$WEATHERCODE\"}"
