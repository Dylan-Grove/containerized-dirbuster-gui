# Containerized Dirbuster GUI
 
This project provides a Docker container that runs Dirbuster inside a fully containerized Kali Linux environment with a browser based GUI. It comes with:
 
- A **Dockerfile** that builds a Kali Linux container.
- A **startup script** (`startup.sh`) to launch a VNC server with noVNC for browser-based GUI access.
- A folder (`/dirbuster-words`) containing common wordlists for Dirbuster.
 
Dirbuster’s graphical interface is available via your browser so you can easily target your server without needing a local X server.
 
---
 
## Features
 
- **Kali Linux Base:** Uses the latest Kali Linux rolling release.
- **Dirbuster Installed:** Dirbuster is pre-installed and ready to run.
- **GUI via VNC/noVNC:** Uses TigerVNC, Openbox, and noVNC to provide a graphical interface accessible at `http://localhost:6080/vnc.html`.
- **Custom Wordlists:** Includes a folder with common Dirbuster wordlists for your scanning needs.
- **Automatic Setup:** The container fixes common TigerVNC configuration issues and starts the necessary services automatically.
 
---
 
## Quickstart
 
1. **Build the Container:**  
   Copy the build command and run it in your repository folder:
   
       ```docker build -t dirbuster-gui .```
 
2. **Run the Container:**  
   Run the container with port mapping for noVNC:
   
       ```docker run -it -p 6080:6080 dirbuster-gui```
 
3. **Access the GUI:**  
   Open your browser and navigate to:  
   [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html)  
   Click **Connect** to access the VNC session.
 
4. **Run Dirbuster:**  
   - Enter the hostname of your target server.
   - Select your desired wordlist from the `/dirbuster-words` directory.
   - Start the scan.
 
---
 
## File Structure
 ```
       .
       ├── Dockerfile          # Builds the Kali Linux container with Dirbuster and VNC/noVNC
       ├── startup.sh          # Startup script to launch TigerVNC and noVNC
       └── dirbuster-words/    # Folder containing common wordlists for Dirbuster
 ```
---
 
## startup.sh
 
Make sure you have a `startup.sh` in your repository (it is copied into the container) that starts the VNC server and noVNC. For example:
``` 
       #!/bin/bash
       # Start VNC server on display :1 with the configured xstartup
       vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None -localhost no
 
       # Start noVNC/websockify to bridge port 6080 to VNC's port 5901
       websockify --web=/usr/share/novnc 6080 localhost:5901
```
---
 
## Usage
 
1. **Customize if Needed:**  
   - Modify `/dirbuster-words` to include any additional wordlists.
   - Adjust the `xstartup` script within the Dockerfile if you need to launch extra tools at startup.
 
2. **Running the Container:**  
   Use the build and run commands provided in the Dockerfile comments to start your container.  
   Once running, connect via your browser, and you’re ready to use Dirbuster.
 
---
 
## Final Notes
 
- **Security:** This container runs a VNC server without authentication for convenience. In a production or multi-user environment, consider adding authentication.
- **Extensibility:** Feel free to extend this container by adding other Kali tools or custom configurations as needed.
 
Happy scanning!
