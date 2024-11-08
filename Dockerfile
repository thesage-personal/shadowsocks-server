# Start from the official shadowsocks-libev image
FROM shadowsocks/shadowsocks-libev

# Set environment variables for configuration
ENV PORT=443 \
    PASSWORD=<password> \
    METHOD=aes-256-gcm \
    OBFS_PLUGIN=v2ray-plugin \
    OBFS_OPTS="server"

# Switch to root temporarily to install packages and copy files
USER root

# Create a non-root user and switch to that user
RUN adduser -D nonrootuser
USER nonrootuser

# Copy the v2ray-plugin tar file into the container
COPY v2ray-plugin-linux-amd64-v1.3.2.tar.gz /tmp/

# Install required dependencies and extract the v2ray plugin
RUN apk update && apk add --no-cache \
    curl \
    tar \
    && tar -zxvf /tmp/v2ray-plugin-linux-amd64-v1.3.2.tar.gz -C /usr/local/bin/ \
    && rm -rf /tmp/v2ray-plugin-linux-amd64-v1.3.2.tar.gz

# Change ownership of /usr/local/bin to nonrootuser
RUN chown -R nonrootuser:nonrootuser /usr/local/bin

# Switch back to nonrootuser for running the server
USER nonrootuser

# Expose both TCP and UDP on the server port
EXPOSE 443/tcp
EXPOSE 443/udp

# Run the shadowsocks-libev server with custom configuration
CMD ss-server \
    -s 0.0.0.0 \
    -p ${PORT} \
    -k ${PASSWORD} \
    -m ${METHOD} \
    --plugin /usr/local/bin/v2ray-plugin_linux_amd64 \
    --plugin-opts ${OBFS_OPTS} \
    --fast-open \
    --reuse-port
