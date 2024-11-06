# Start from the official shadowsocks-libev image
FROM shadowsocks/shadowsocks-libev

# Set environment variables for configuration
ENV PASSWORD=<password> \
    METHOD=aes-256-gcm  

# Expose both TCP and UDP on the server port
EXPOSE 8388/tcp
EXPOSE 8388/udp

# Run the shadowsocks-libev server with custom configuration
CMD ss-server \
    -s 0.0.0.0 \
    -p 8388 \
    -k ${PASSWORD} \
    -m ${METHOD} \
    --fast-open \
    --reuse-port
