FROM ubuntu:23.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    xorg \
    xfce4 \
    xrdp \
    sudo

RUN apt-get install -y xorgxrdp

# Configure XRDP to use XFCE
RUN echo "xfce4-session" > /etc/skel/.Xclients && \
    chmod +x /etc/skel/.Xclients && \
    cp /etc/skel/.Xclients /root/.Xclients

# Create a new user for the XRDP login
RUN useradd -m -s /bin/bash xrdpuser && \
    echo "xrdpuser:xrdpuser" | chpasswd && \
    adduser xrdpuser sudo

# Create a new user for the XRDP login
RUN useradd -m -s /bin/bash guest && \
    echo "guest:guest" | chpasswd && \
    adduser guest sudo

# Set proper ownership and permissions
RUN chown -R guest:guest /home/guest

# Create .Xclients file and set permissions
RUN echo "xfce4-session" > /home/guest/.Xclients && \
         chmod +x /home/guest/.Xclients

# COPY --chown=guest:guest /etc/skel/.Xclients /home/guest/.Xclients

# Expose the RDP port
EXPOSE 3389

RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Copy the startup script
COPY start-xrdp.sh /usr/bin/

RUN chmod +x /usr/bin/start-xrdp.sh

# Start XRDP and XRDP session manager
CMD ["start-xrdp.sh"]