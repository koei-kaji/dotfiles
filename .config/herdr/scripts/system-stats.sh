#!/bin/zsh

cores=$(/usr/sbin/sysctl -n hw.logicalcpu 2>/dev/null)

cpu=$(
  /bin/ps -A -o %cpu= |
    /usr/bin/awk -v cores="$cores" '
      { total += $1 }
      END {
        if (cores > 0) {
          usage = total / cores
          if (usage > 100) usage = 100
          printf "%.0f", usage
        } else {
          printf "?"
        }
      }
    '
)

free=$(
  /usr/bin/memory_pressure -Q 2>/dev/null |
    /usr/bin/awk '
      /System-wide memory free percentage/ {
        gsub(/%/, "", $5)
        print $5
      }
    '
)

if [[ "$free" == <-> ]]; then
  memory=$((100 - free))
else
  memory="?"
fi

printf ' %s%% |  %s%%' "$cpu" "$memory"
