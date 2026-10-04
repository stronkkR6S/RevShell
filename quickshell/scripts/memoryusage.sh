#!/bin/bash
TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
AVAIL_MEM=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

USED_MEM=$((TOTAL_MEM - AVAIL_MEM))
USED_PCT=$((USED_MEM * 100 / TOTAL_MEM))

TOTAL_GB=$(echo "scale=2; $TOTAL_MEM / 1024 / 1024" | bc)
AVAIL_GB=$(echo "scale=2; $AVAIL_MEM / 1024 / 1024" | bc)
USED_GB=$(echo "scale=2; $USED_MEM / 1024 / 1024" | bc)

cat <<EOF
{
  "total_mem_gb": $TOTAL_GB,
  "available_mem_gb": $AVAIL_GB,
  "used_mem_gb": $USED_GB,
  "used_percent": $USED_PCT
}
EOF
