#!/usr/bin/env bash
df -h --output=size,used,avail,pcent / | tail -n +2 | awk '{
    gsub(/[A-Za-z%]/, "", $1);
    gsub(/[A-Za-z%]/, "", $2);
    gsub(/[A-Za-z%]/, "", $3);
    gsub(/[A-Za-z%]/, "", $4);
    print "{\"total\": " $1 ", \"used\": " $2 ", \"avail\": " $3 ", \"use_percent\": " $4 "}";
    fflush();
}'

