#!/bin/bash

GUEST_PASS="guest"

# Check if GUEST_PASS is set and update the password
if [ ! -z "$GUEST_PASS" ]; then
    echo "guest:$GUEST_PASS" | chpasswd
fi

# Start xrdp and sesman (only one method needed)
/etc/init.d/xrdp start

# Now keep the container running
tail -f /dev/null

