# Create SSH-Key

Simple note on how to setup your own SSH-key for use with any cloud or local server solution.

- Generate SSH-key: `ssh-keygen -t ed25519 -C "ola.nordmann@mycompany.com"`
- Prompted to give file name: `olanordmann`
- Passphrase: `<your-personal-passphrase>`
- Recommend to store this in your personal space in a password manager (e.g. 1Password).
- Add the SSH-key to the server(s). Ask someone with admin rights to add you to the server(s).

To SSH into the server (recommended to specify the SSH key):
- SSH into the server:
    - From Windows: `ssh -i C:\Users\olanordmann\.ssh\olanordmann olanordmann@SERVERIP`
    - From Linux: `ssh -i /home/olanordmann/.ssh/olanordmann olanordmann@SERVERIP`
- If you are using VS Code with the **Remote - SSH** extension, then setup your `.../.ssh/config`-file for example like this:
    - For Windows:
        ```
        Host 12.139.46.231
            HostName 12.139.46.231
            IdentityFile C:\Users\ola.nordmann\.ssh\olanordmann
            User olanordmann
        ```
    - For Linux:
        ```
        Host 12.139.46.231
            HostName 12.139.46.231
            IdentityFile /home/olanordmann/.ssh/olanordmann
            User olanordmann
        ```


