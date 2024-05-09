# Use Ubuntu 23.04 as the base image
FROM ubuntu:23.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND noninteractive

# Update the package repository and install essential packages
RUN apt-get update && apt-get install -y \
    ca-certificates \
    software-properties-common \
    sudo \
    vim \
    nano \
    dbus-x11 \
    xorg \
    xrdp \
    xorgxrdp \
    xfce4 \
    xfce4-goodies \
    xserver-xorg-video-dummy \
    supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*deb

# Add the guest user and set up necessary permissions
RUN useradd -m -s /bin/bash guest \
    && echo "guest:guest" | chpasswd \
    && adduser guest sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure XRDP to use XFCE and adjust xrdp settings for Docker compatibility
RUN echo xfce4-session > /etc/skel/.Xclients \
    && chmod +x /etc/skel/.Xclients \
    && cp /etc/skel/.Xclients /home/guest/ \
    && sed -i 's/^test -x \/etc\/X11\/Xsession && exec \/etc\/X11\/Xsession/exec startxfce4/' /etc/xrdp/startwm.sh \
    && sed -i 's/fork=true/fork=false/g' /etc/xrdp/xrdp.ini \
    && sed -i 's/AllowRootLogin=true/AllowRootLogin=false/g' /etc/xrdp/sesman.ini

# DBus and other configuration
RUN mkdir /var/run/dbus \
    && dbus-uuidgen > /var/lib/dbus/machine-id \
    && chown -R messagebus:messagebus /var/run/dbus

# Expose the RDP port
EXPOSE 3389

# Locale settings
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set up supervisord to manage the XRDP and XFCE sessions
RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy and set permissions for the startup script
COPY start-xrdp.sh /usr/bin/
RUN chmod +x /usr/bin/start-xrdp.sh

# Use supervisord to start services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

