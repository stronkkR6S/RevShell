#!/bin/bash
#
BRIGHTNESS_LEVEL=$(brightnessctl get -P)
echo "{\"brightnesslevel\":\"$BRIGHTNESS_LEVEL\"}"
