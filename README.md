# claude-code-isonet
Claude Code in isolated network

## Why

In conventional setups where `iptables` are configured within a container, Claude Code could potentially execute a command with `sudo` to disable the firewall rules if `sudo` is allowed. To prevent this, `claude-code-isonet` manages network access control **outside** the container, creating a more secure environment.


## How to use

Run the follwing HTTP proxy in a teminal.

```bash
./squid.sh
```

Run the follwing relay in another teminal.
```bash
./proxy_relay.sh
```

Build a sandbox Docker image in another terminal.

```bash
./build_claude_isonet.sh
```

Run a docker container. `$PWD:/container_share` is a shared directory.
```
./claude_isonet.sh
```

## Network access control

Network access is managed by domain name in `squid.conf`, not by IP address. You can edit the `allowed_domains` list to control which sites Claude Code can access.

```conf
acl allowed_domains dstdomain .github.com .registry.npmjs.org .api.anthropic.com .console.anthropic.com .sentry.io .statsig.anthropic.com .statsig.com .ubuntu.com
```

To apply changes to `squid.conf`, simply stop `./squid.sh` by Ctrl+C and restart the `./squid.sh` again.

## How it works

This project uses `docker run --network none` to create a container with no network access. The container communicates with the outside world through an HTTP proxy on the host machine. This connection is securely relayed from the container to the host via a Unix domain socket, ensuring all traffic is filtered by the external proxy.

The architecture looks like this:

```
+------------------ Host machine -------------------+
|                                                   |
|  Internet <--> Squid <--> socat                   |
|              (:13128)     (Relay)                 |
+---------------------------------------------------+
                              ^
                              | (Volume Mount)
                              | (Unix domain socket)
                              | /tmp/squid_for_claude.sock 
                              v
+------------ Container (network=none) -------------+
|                                                   |
|             socat <--> Claude Code App            |
|             (Relay)   (via HTTP_PROXY)            |
+---------------------------------------------------+
```
