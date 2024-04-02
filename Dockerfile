# Use Alpine Linux as base image
FROM alpine:latest

# Update package repository and install required packages
RUN apk update && \
    apk add --no-cache wget curl tar jq

# Set the working directory
WORKDIR /usr/local/bin

# Fetch the latest version of Bomber from GitHub releases
RUN latest_version=$(curl -s https://api.github.com/repos/bomber-project/bomber/releases/latest | jq -r .tag_name) && \
    echo "Latest version of Bomber: $latest_version" && \
    wget "https://github.com/bomber-project/bomber/releases/download/${latest_version}/bomber_${latest_version#v}_linux_amd64.tar.gz" && \
    tar -xzvf "bomber_${latest_version#v}_linux_amd64.tar.gz" && \
    rm "bomber_${latest_version#v}_linux_amd64.tar.gz"

# Set the entrypoint or command for Bomber
ENTRYPOINT ["entrypoint.sh"]  # Replace this with the actual command to start Bomber
