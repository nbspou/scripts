#!/bin/bash

# Check if initial setup has been done
SETUP_FLAG="/root/.initial_setup_done"

if [ ! -f "$SETUP_FLAG" ]; then
    echo "Performing initial setup..."

    # Update package lists
    rm /var/lib/apt/lists/*
    rm /var/lib/apt/lists/partial/*
    apt-get update

    # Install necessary packages
    apt-get install aptitude libcurl4-openssl-dev libomp-dev clang cmake ninja-build nano nvtop htop ncurses-term lshw -y

    # Create flag file to indicate setup is done
    touch "$SETUP_FLAG"
    echo "Initial setup completed."
else
    echo "Initial setup already done. Skipping package updates and installation."
fi

# Update bashrc and language settings only if TERM=putty is not already present
if ! grep -q "export TERM=putty" ~/.bashrc; then
    echo -e '\nexport TERM=putty' >> ~/.bashrc
    echo 'export LANG=C.utf8' >> ~/.bashrc
    echo 'export LC_ALL=C.utf8' >> ~/.bashrc
    source ~/.bashrc
fi

# Function to clone a Git repository
clone_git_repo() {
    REPO_URL="$1"
    REPO_DIR="$2"

    if [ -d "$REPO_DIR" ]; then
        echo "Repository already exists at $REPO_DIR. Skipping clone."
    else
        echo "Cloning repository $REPO_URL..."
        git clone "$REPO_URL" "$REPO_DIR"
        if [ $? -eq 0 ]; then
            echo "Repository cloned successfully to $REPO_DIR."
        else
            echo "Failed to clone repository $REPO_URL. Please check your network connection and permissions."
        fi
    fi
}

# Clone the Git repositories if they don't exist
clone_git_repo "https://github.com/ggerganov/llama.cpp.git" "$HOME/llama.cpp"

# Check and set timezone only if necessary
current_time=$(date +%Z)
if [ "$current_time" != "UTC" ]; then
    if command -v timedatectl &> /dev/null; then
        timedatectl set-timezone UTC
    elif [ -d "/usr/share/zoneinfo" ]; then
        ln -sf /usr/share/zoneinfo/UTC /etc/localtime
        echo "UTC" > /etc/timezone
    else
        echo "Unable to set timezone to UTC. Current timezone: $current_time"
    fi
else
    echo "Timezone is already set to UTC. Skipping timezone change."
fi

# Install Node.js 22.x only if not installed or version is different
if ! command -v node &> /dev/null || [[ $(node -v) != v22* ]]; then
    curl -sSL https://deb.nodesource.com/setup_22.x | bash
    apt install nodejs -y
fi

# Install Ollama only if not already installed
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
fi

touch ~/.no_auto_tmux

# Install pm2 globally
npm install -g pm2

# List pm2 processes
pm2 list
pm2 resurrect
