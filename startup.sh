#!/bin/bash
# Start the VNC server on :1 with no auth
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None

# Start noVNC
websockify --web=/usr/share/novnc 6080 localhost:5901
