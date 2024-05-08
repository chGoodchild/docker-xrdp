FROM ubuntu:23.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    xorg \
    xfce4 \
    xrdp \
    sudo

# Configure XRDP to use XFCE
RUN echo "xfce4-session" > /etc/skel/.Xclients && \
    chmod +x /etc/skel/.Xclients && \
    cp /etc/skel/.Xclients /root/.Xclients

# Create a new user for the XRDP login
RUN useradd -m -s /bin/bash xrdpuser && \
    echo "xrdpuser:xrdpuser" | chpasswd && \
    adduser xrdpuser sudo

# Expose the RDP port
EXPOSE 3389

# Use the default XRDP start script
CMD ["/etc/init.d/xrdp", "start"]

