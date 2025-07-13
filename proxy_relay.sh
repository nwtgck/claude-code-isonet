#!/bin/bash
# `docker run` may make the directory by -v option
rmdir /tmp/squid_for_claude.sock 2>/dev/null
echo "Starting relay..."
socat UNIX-LISTEN:/tmp/squid_for_claude.sock,fork TCP:127.0.0.1:13128
