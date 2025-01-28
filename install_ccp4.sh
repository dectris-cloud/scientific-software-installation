#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Set non-interactive mode for installation
export DEBIAN_FRONTEND=noninteractive

# Define usage function
usage() {
    echo "Usage: $0 [-d <installation_directory>]"
    exit 1
}

# Parse command-line arguments
INSTALL_DIR="/opt/ccp4"
while getopts "d:" opt; do
    case $opt in
        d)
            INSTALL_DIR="$OPTARG"
            ;;
        *)
            usage
            ;;
    esac
done

# Check if tar ball has been provided
CCP4_TARBALL=$(ls install_files/ccp4*.tar.gz 2>/dev/null | head -n 1)
if [[ -f $CCP4_TARBALL ]]; then
    echo "Found CCP4 tarball, will proceed with the ccp4 installation"
else
    echo "Error: No CCP4 tarball found in 'install_files/'. Create the the install_files folder and download the tarball to it from https://www.ccp4.ac.uk/download/#os=linux."
    exit 1
fi

# Update package lists and install required dependencies
echo "Updating package lists and installing dependencies..."
sudo apt-get update && \
sudo apt-get install -y \
    wget \
    build-essential \
    python3 \
    python3-pip \
    libglu1-mesa \
    libfontconfig1 \
    libxrender1 \
    libxt6 \
    libxext6 \
    libxcb-xinput0 \
    libxcb1 \
    libx11-xcb1 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-xfixes0 \
    libxcb-keysyms1 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-sync1 \
    libxcb-randr0 \
    libxcb-util1 \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    csh \
    tcsh \
    libncurses5 && \
sudo rm -rf /var/lib/apt/lists/*

# Create installation directory
echo "Creating installation directory at $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"

# Install CCP4
echo "Installing CCP4 from $CCP4_TARBALL..."
sudo tar --strip-components=1 -xzf "$CCP4_TARBALL" -C "$INSTALL_DIR"
sudo "$INSTALL_DIR/BINARY.setup" --run-from-script
echo "source $INSTALL_DIR/bin/ccp4.setup-sh" >> /etc/bash.bashrc


# Activate environment
echo "Sourcing CCP4 environment setup..."
. "$INSTALL_DIR/bin/ccp4.setup-sh"

echo "Installation complete. CCP4 is now installed in $INSTALL_DIR and ready to use."
