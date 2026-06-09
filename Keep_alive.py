#!/usr/bin/env python3
"""
GitHub Codespace keep‑alive script (educational use only).
Writes a timestamp to a file every 10 minutes to simulate activity.
Press Ctrl+C to stop.
"""

import time
import os
import sys
from datetime import datetime

def keep_alive(interval_minutes=10, log_file="keep_alive.log"):
    """
    Append current timestamp to log_file every 'interval_minutes' minutes.
    """
    interval_seconds = interval_minutes * 60
    print(f"Keep‑alive started. Will write to '{log_file}' every {interval_minutes} minute(s).")
    print("Press Ctrl+C to stop.\n")

    try:
        while True:
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            with open(log_file, "a") as f:
                f.write(f"{timestamp} - Keep alive signal\n")
            print(f"[{timestamp}] Wrote keep‑alive entry")
            time.sleep(interval_seconds)
    except KeyboardInterrupt:
        print("\nKeep‑alive stopped by user.")
        sys.exit(0)

if __name__ == "__main__":
    # You can change the interval (in minutes) by passing an argument:
    # python keep_alive.py 5   -> every 5 minutes
    interval = 10
    if len(sys.argv) > 1:
        try:
            interval = int(sys.argv[1])
        except ValueError:
            print("Usage: python keep_alive.py [interval_in_minutes]")
            sys.exit(1)
    keep_alive(interval_minutes=interval)
