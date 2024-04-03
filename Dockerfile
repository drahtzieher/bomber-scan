# Use Alpine Linux as base image
FROM alpine:latest
# Update package repository and install required packages
RUN apk update && \
    apk add --no-cache wget curl tar jq
COPY entrypoint.sh /entrypoint.sh

# Set the working directory
WORKDIR /usr/local/bin

# Define the default version of Bomber
ARG BOMBER_VERSION=v0.4.8
# Fetch the specified version of Bomber from GitHub releases
RUN wget "https://github.com/devops-kung-fu/bomber/releases/download/${BOMBER_VERSION}/bomber_${BOMBER_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzvf "bomber_${BOMBER_VERSION#v}_linux_amd64.tar.gz" && \
    rm "bomber_${BOMBER_VERSION#v}_linux_amd64.tar.gz"
WORKDIR /

# Set the entrypoint or command for Bomber
ENTRYPOINT ["/entrypoint.sh"]  # Replace this with the actual command to start Bomber
