# Use the devcontainers base image (Ubuntu-based)
FROM mcr.microsoft.com/devcontainers/base:ubuntu


# Install packages needed for installers and general use
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
ca-certificates curl gnupg lsb-release unzip tar && \
rm -rf /var/lib/apt/lists/*


# Install kubectl (use stable release dynamically)
RUN KUBECTL_RELEASE=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
&& curl -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_RELEASE}/bin/linux/amd64/kubectl" \
&& chmod +x /usr/local/bin/kubectl \
&& /usr/local/bin/kubectl version --client --short || true


# Install Docker CLI (static binary)
ARG DOCKER_CLI_VERSION=24.0.0
RUN curl -L -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz" \
&& tar -xzf /tmp/docker.tgz -C /tmp \
&& mv /tmp/docker/* /usr/local/bin/ \
&& rm -rf /tmp/docker.tgz /tmp/docker \
&& docker --version || true


# Keep image size small
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set a default non-root user (devcontainers default)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID


# Ensure /home/vscode/bin is in PATH for postCreateCommand installs (if used)
ENV PATH=/home/vscode/bin:$PATH


# (Optionally) a helpful healthcheck to verify kubectl is present
HEALTHCHECK --interval=5m --timeout=10s --start-period=30s --retries=3 \
CMD ["/bin/sh", "-c", "command -v kubectl >/dev/null 2>&1 || exit 1"]