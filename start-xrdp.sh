#!/bin/bash

# Update guest password if GUEST_PASS is set
if [ ! -z "$GUEST_PASS" ]; then
    echo "guest:$GUEST_PASS" | chpasswd
fi

dbus-uuidgen > /var/lib/dbus/machine-id
dbus-daemon --system

# Start XRDP components
xrdp-sesman --nodaemon &
sleep 1
xrdp --nodaemon

