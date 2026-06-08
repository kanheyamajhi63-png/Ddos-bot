
#!/bin/bash

# keepalive.sh – Fake terminal activity to prevent Codespace auto-sleep
# WARNING: This may violate GitHub's Acceptable Use Policy.
#          Use only for brief tests, not for 24/7 operation.

LOG_FILE="$HOME/keepalive.log"
PID_FILE="$HOME/keepalive.pid"

start_loop() {
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "Keepalive is already running (PID $(cat "$PID_FILE"))."
        exit 1
    fi

    echo "Starting keepalive loop (logs to $LOG_FILE)..."
    # Write the loop in the background
    (
        while true; do
            date "+%Y-%m-%d %H:%M:%S - Keepalive" >> "$LOG_FILE"
            sleep 60
        done
    ) &
    echo $! > "$PID_FILE"
    echo "Started with PID $!. Use '$0 stop' to stop."
}

stop_loop() {
    if [[ -f "$PID_FILE" ]]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            kill "$PID"
            echo "Stopped keepalive loop (PID $PID)."
            rm -f "$PID_FILE"
        else
            echo "No running keepalive process found. Removing stale PID file."
            rm -f "$PID_FILE"
        fi
    else
        echo "PID file not found. Is keepalive running?"
    fi
}

status_loop() {
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "Keepalive is running (PID $(cat "$PID_FILE"))."
        echo "Last 3 log entries:"
        tail -n 3 "$LOG_FILE" 2>/dev/null || echo "(no log entries yet)"
    else
        echo "Keepalive is not running."
    fi
}

case "$1" in
    start)
        start_loop
        ;;
    stop)
        stop_loop
        ;;
    status)
        status_loop
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac
