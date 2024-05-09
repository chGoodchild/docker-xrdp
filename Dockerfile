FROM ubuntu:23.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    xorg \
    xrdp \
    sudo \
    nano

RUN apt-get install -y xorgxrdp
RUN apt-get install -y dbus-x11
RUN apt-get install -y xfce4 xfce4-goodies

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

RUN chmod 1777 /tmp && chmod 0755 /run
RUN mkdir /var/run/dbus
ENV DBUS_SESSION_BUS_ADDRESS=unix:path=/var/run/dbus/system_bus_socket
ENV HOME=/home/guest

ENV XRDP_LOG_LEVEL=DEBUG

# Set proper ownership and permissions
RUN chown -R guest:guest /home/guest

# Create .Xclients file and set permissions
RUN echo "xfce4-session" > /home/guest/.Xclients && \
    chmod +x /home/guest/.Xclients && \
    ls -l /home/guest/

# COPY --chown=guest:guest /etc/skel/.Xclients /home/guest/.Xclients

# Modify startwm.sh to start XFCE
RUN sed -i 's|^test -x /etc/X11/Xsession && exec /etc/X11/Xsession|exec startxfce4|' /etc/xrdp/startwm.sh

# Expose the RDP port
EXPOSE 3389

# Locale settings
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Copy and set permissions for the startup script
COPY start-xrdp.sh /usr/bin/

RUN chmod +x /usr/bin/start-xrdp.sh

# Start XRDP and XRDP session manager
CMD ["start-xrdp.sh"]

