#!/usr/bin/env bash
set -euo pipefail

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/quickshell-bar.pid"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"

if [[ -f "$PIDFILE" ]]; then
    PID=$(cat "$PIDFILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID" 2>/dev/null || true
        rm -f "$PIDFILE"
        exit 0
    fi
    rm -f "$PIDFILE"
fi

if pgrep -x quickshell >/dev/null 2>&1; then
    pkill -x quickshell
else
    nohup quickshell >/dev/null 2>&1 &
    echo $! > "$PIDFILE"
fi
