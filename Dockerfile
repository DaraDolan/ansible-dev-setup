FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    python3 \
    python3-pip \
    ssh \
    vim \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN pip3 install ansible

# Create a test user (similar to your WSL user)
RUN useradd -m testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/testuser

# Switch to testuser
USER testuser
WORKDIR /home/testuser

# Copy your Ansible files
COPY --chown=testuser:testuser . /home/testuser/ansible-dotfiles/

# Set working directory to the playbook location
WORKDIR /home/testuser/ansible-dotfiles

CMD ["/bin/bash"]
