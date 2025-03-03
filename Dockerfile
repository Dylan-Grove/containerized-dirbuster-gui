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

# Write the xstartup
RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
dirbuster &\n\
exec openbox-session\n\
' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Startup script that starts the VNC server + noVNC
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

COPY /dirbuster-words /dirbuster-words

EXPOSE 6080
CMD ["/startup.sh"]


# docker build -t kali-container .
# docker run -it -p 6080:6080 kali-container