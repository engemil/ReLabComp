#!/usr/bin/env python

import time
from datetime import datetime

# File where timestamps will be stored
OUTPUT_FILE = "test_script_2_timestamps.log"

def write_timestamp():
    while True:
        # Get current timestamp
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        # Open file in append mode, write timestamp, and close
        with open(OUTPUT_FILE, 'a') as f:
            f.write(f"Timestamp: {current_time}\n")
            print(f"Timestamp: {current_time}")  # Also print to console
        
        # Wait 5 seconds
        time.sleep(5)

if __name__ == "__main__":
    print(f"Starting timestamp writer to {OUTPUT_FILE}")
    try:
        write_timestamp()
    except KeyboardInterrupt:
        print("\nStopped by user")

