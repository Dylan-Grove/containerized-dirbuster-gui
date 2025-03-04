Containerized Dirbuster
This project provides a Docker container that runs Dirbuster inside a fully containerized Kali Linux environment. It comes with:

A Dockerfile that builds a Kali Linux container.
A startup script (startup.sh) to launch a VNC server with noVNC for browser-based GUI access.
A folder (/dirbuster-words) containing common wordlists for Dirbuster.
Dirbuster’s graphical interface is available via your browser so you can easily target your server without needing a local X server.

Features
Kali Linux Base: Uses the latest Kali Linux rolling release.
Dirbuster Installed: Dirbuster is pre-installed and ready to run.
GUI via VNC/noVNC: Uses TigerVNC, Openbox, and noVNC to provide a graphical interface accessible at http://localhost:6080/vnc.html.
Custom Wordlists: Includes a folder with common Dirbuster wordlists for your scanning needs.
Automatic Setup: The container fixes common TigerVNC configuration issues and starts the necessary services automatically.
Quickstart
Build the Container:
Open the Dockerfile and copy the build command (shown below) and run it in your repository folder:

bash
Copy
docker build -t kali-container .
Run the Container:
Run the container with port mapping for noVNC:

bash
Copy
docker run -it -p 6080:6080 kali-container
Access the GUI:
Open your browser and navigate to:
http://localhost:6080/vnc.html
Click Connect to access the VNC session.

Run Dirbuster:

Enter the hostname of your target server.
Select your desired wordlist from the /dirbuster-words directory.
Start the scan.
File Structure
bash
Copy
.
├── Dockerfile          # Builds the Kali Linux container with Dirbuster and VNC/noVNC
├── startup.sh          # Startup script to launch TigerVNC and noVNC
└── dirbuster-words/    # Folder containing common wordlists for Dirbuster
Dockerfile
dockerfile
Copy
FROM kalilinux/kali-rolling:latest

RUN apt-get update && apt-get install -y \
    dirbuster \
    openbox \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    xfonts-base

# Fix the TigerVNC migration bug
RUN rm -rf /root/.vnc /root/.config/tigervnc && \
    mkdir -p /root/.config/tigervnc && \
    ln -s /root/.config/tigervnc /root/.vnc && \
    chown -R root:root /root/.config && \
    chmod -R 700 /root/.config

# Write the xstartup script to launch Dirbuster and Openbox
RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
dirbuster &\n\
exec openbox-session\n\
' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Copy startup script and wordlist folder into the container
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
COPY /dirbuster-words /dirbuster-words

EXPOSE 6080
CMD ["/startup.sh"]

# Build with: docker build -t kali-container .
# Run with:   docker run -it -p 6080:6080 kali-container
startup.sh
Make sure you have a startup.sh in your repository (it is copied into the container) that starts the VNC server and noVNC. For example:

bash
Copy
#!/bin/bash
# Start VNC server on display :1 with the configured xstartup
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None -localhost no

# Start noVNC/websockify to bridge port 6080 to VNC's port 5901
websockify --web=/usr/share/novnc 6080 localhost:5901
Usage
Customize if Needed:

Modify /dirbuster-words to include any additional wordlists.
Adjust the xstartup script within the Dockerfile if you need to launch extra tools at startup.
Running the Container:
Use the build and run commands provided in the Dockerfile comments to start your container.
Once running, connect via your browser, and you’re ready to use Dirbuster.

Final Notes
Security: This container runs a VNC server without authentication for convenience. In a production or multi-user environment, consider adding authentication.
Extensibility: Feel free to extend this container by adding other Kali tools or custom configurations as needed.
Happy scanning!
