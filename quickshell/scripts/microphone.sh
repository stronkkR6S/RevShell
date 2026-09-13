 #!/bin/bash
#  MICROPHONELEVEL=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{print $2 * 100}')
# [ -z "$MICROPHONELEVEL" ] && MICROPHONELEVEL="NFound"

MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -o 'MUTED')
[ -z "$MUTED" ] && MUTED=""


echo "{\"state\":\"$MUTED\"}"
