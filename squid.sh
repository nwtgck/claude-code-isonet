#!/bin/bash
docker run --rm -p 127.0.0.1:13128:3128 -it --name squid-for-claude -v "$(pwd)/squid.conf:/etc/squid/squid.conf" ubuntu/squid /usr/sbin/squid -N
