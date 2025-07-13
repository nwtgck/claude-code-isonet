FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl socat tmux sudo

RUN echo "Acquire::http::Proxy \"http://127.0.0.1:3128/\";" > /etc/apt/apt.conf.d/proxy.conf && \
    echo "Acquire::https::Proxy \"http://127.0.0.1:3128/\";" >> /etc/apt/apt.conf.d/proxy.conf

RUN useradd -u 1000 -rm -d /home/user -s /bin/bash user && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER user
ENV HOME=/home/user

ENV NVM_DIR=$HOME/.nvm
RUN bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 22"
RUN bash -c "source $NVM_DIR/nvm.sh && npm install -g @anthropic-ai/claude-code"
# Avoid ~/.claude.json
ENV CLAUDE_CONFIG_DIR=/home/user/.claude

ENV HTTP_PROXY=http://127.0.0.1:3128
ENV ALL_PROXY=http://127.0.1:3128
RUN bash -c "source $NVM_DIR/nvm.sh && npm config set proxy http://127.0.0.1:3128"

CMD ["/bin/bash", "-c", "echo \"127.0.0.1 $(hostname)\" | sudo tee -a /etc/hosts &>/dev/null; sudo chown user:user /tmp/squid_for_claude.sock; (while true; do socat TCP-LISTEN:3128,reuseaddr,fork UNIX-CONNECT:/tmp/squid_for_claude.sock; done) & exec /bin/bash"]
