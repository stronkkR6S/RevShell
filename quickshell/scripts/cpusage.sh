#!/bin/bash
vmstat 2 | awk 'NR>2 {printf "%.0f\n", 100-$15; fflush()}'
