#!/bin/bash

GUEST_PASS="guest"

# Check if GUEST_PASS is set and update the password
if [ ! -z "$GUEST_PASS" ]; then
    echo "guest:$GUEST_PASS" | chpasswd
fi

# Start xrdp-sesman in the background
xrdp-sesman --nodaemon &

# Start xrdp in the foreground
xrdp --nodaemon

service xrdp start
service xrdp-sesman start
