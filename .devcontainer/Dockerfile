# .devcontainer/Dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TERRAFORM_VERSION=1.6.8
ARG DOCKER_CLI_VERSION=24.0.0

# Install basics
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl unzip gnupg lsb-release tar && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl (stable)
RUN KUBECTL_RELEASE=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
  && curl -L -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_RELEASE}/bin/linux/amd64/kubectl" \
  && chmod +x /usr/local/bin/kubectl

# Install Docker CLI (static)
RUN curl -L -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz" \
  && tar -xzf /tmp/docker.tgz -C /tmp \
  && mv /tmp/docker/* /usr/local/bin/ \
  && rm -rf /tmp/docker.tgz /tmp/docker

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
  && unzip /tmp/awscliv2.zip -d /tmp \
  && /tmp/aws/install --update && rm -rf /tmp/aws /tmp/awscliv2.zip

# Install Terraform
RUN curl -L -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && unzip /tmp/terraform.zip -d /usr/local/bin/ \
  && rm -f /tmp/terraform.zip

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ensure PATH includes /usr/local/bin (default) and non-root user home bin
ENV PATH=/home/vscode/bin:/usr/local/bin:$PATH

# Optional labels
LABEL devcontainer=\"true\"
