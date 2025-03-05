import serial
import time
from datetime import datetime


com_port = '/dev/ttyACM1' # change to your Arduino's port. # For Linux use `identify_port.sh`-script to figure out the port name.
baud_rate = 9600 # change to your Arduino's baud rate
on_value = "PWR_ON"
off_value = "PWR_OFF"

print(f"Wait! Timing test is starting...")

# Configure serial port
ser = serial.Serial(com_port, baud_rate, timeout=1)
# Give some time for serial connection to establish
time.sleep(2)

# Store the start time when script begins
start_time = datetime.now()
print(f"Started at: {start_time}")
print(f"NB! First power on/off duration might be incorrect...")

start_on_time = datetime.now()
start_off_time = datetime.now()


try:
    while True:import serial
import time
from datetime import datetime


com_port = '/dev/ttyACM1' # change to your Arduino's port. # For Linux use `identify_port.sh`-script to figure out the port name.
baud_rate = 9600 # change to your Arduino's baud rate
on_value = "PWR_ON"
off_value = "PWR_OFF"

print(f"Wait! Timing test is starting...")

# Configure serial port
ser = serial.Serial(com_port, baud_rate, timeout=1)
# Give some time for serial connection to establish
time.sleep(2)

# Store the start time when script begins
start_time = datetime.now()
print(f"Started at: {start_time}")
print(f"NB! First power on/off duration might be incorrect...")

start_on_time = datetime.now()
start_off_time = datetime.now()


try:
    while True:
        # Read serial line
        if ser.in_waiting > 0:
            # Read and decode the serial data
            data = ser.readline().decode('utf-8').strip()
            
            if data == off_value:
                # Get current time
                current_time = datetime.now()
                start_off_time = current_time

                on_time_duration = (current_time - start_on_time).total_seconds()

                print(f"Time ON duration: {on_time_duration:.2f} seconds")
                print(f"Power OFF at: {current_time}")
                print("-------------------")

            elif data == on_value:
                # Get current time
                current_time = datetime.now()
                start_on_time = current_time
                
                off_time_duration = (current_time - start_off_time).total_seconds()

                print(f"Time OFF duration: {off_time_duration:.2f} seconds")
                print(f"Power ON at: {current_time}")
                print("-------------------")

except KeyboardInterrupt:
    print("\nScript terminated by user")
finally:
    ser.close()
    print("Serial connection closed")

                start_off_time = current_time

                on_time_duration = (current_time - start_on_time).total_seconds()

                print(f"Time ON duration: {on_time_duration:.2f} seconds")
                print(f"Power OFF at: {current_time}")
                print("-------------------")

            elif data == on_value:
                # Get current time
                current_time = datetime.now()
                start_on_time = current_time
                
                off_time_duration = (current_time - start_off_time).total_seconds()

                print(f"Time OFF duration: {off_time_duration:.2f} seconds")
                print(f"Power ON at: {current_time}")
                print("-------------------")

except KeyboardInterrupt:
    print("\nScript terminated by user")
finally:
    ser.close()
    print("Serial connection closed")
