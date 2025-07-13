#!/bin/bash
docker run -it --network none -v "$PWD"/container_share/ws:/home/user/ws -v "$PWD"/container_share/.claude:/home/user/.claude -v /tmp/squid_for_claude.sock:/tmp/squid_for_claude.sock -w /home/user/ws claude-code-isonet
