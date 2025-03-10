# Script Management

How to use these scripts:

- First make them executable:
    ```sh
    chmod +x start_script.sh
    chmod +x list_scripts.sh
    chmod +x enter_script.sh
    chmod +x stop_script.sh
    ```
- Example usage:
    ```sh
    # Start a script
    ./start_script.sh /path/to/your/script.py

    # List running scripts
    ./list_scripts.sh

    # View a script's output (using PID from list_scripts)
    ./enter_script.sh 12345

    # Stop a script (using PID from list_scripts)
    ./stop_script.sh 12345
    ```

