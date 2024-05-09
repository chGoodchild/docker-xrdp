#!/bin/bash

# Update guest password if GUEST_PASS is set
if [ ! -z "$GUEST_PASS" ]; then
    echo "guest:$GUEST_PASS" | chpasswd
fi

# Start xrdp and sesman
xrdp-sesman --nodaemon &
xrdp --nodaemon

