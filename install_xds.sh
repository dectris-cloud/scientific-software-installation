#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Set non-interactive mode for installation
export DEBIAN_FRONTEND=noninteractive

# Define URLs for XDS and Neggia
XDS_URL="https://xds.mr.mpg.de/XDS-INTEL64_Linux_x86_64.tar.gz"
NEGGIA_URL="https://github.com/dectris/neggia/files/6585943/dectris-neggia-1.2.0.el7.tar.gz"

# Set installation directory (default: /opt/xds)
INSTALL_DIR=${XDS_INSTALL_DIR:-/opt/xds}

# Create installation directory
echo "Creating installation directory at $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"

# Download and install XDS
echo "Downloading and installing XDS..."
wget --no-check-certificate -O "$INSTALL_DIR/XDS-INTEL64_Linux_x86_64.tar.gz" "$XDS_URL"
sudo tar --strip-components=1 -xzf "$INSTALL_DIR/XDS-INTEL64_Linux_x86_64.tar.gz" -C "$INSTALL_DIR"
sudo rm "$INSTALL_DIR/XDS-INTEL64_Linux_x86_64.tar.gz"

# Download and install Neggia
echo "Downloading and installing Neggia..."
wget --no-check-certificate -O "$INSTALL_DIR/dectris-neggia.tar.gz" "$NEGGIA_URL"
sudo tar -xzf "$INSTALL_DIR/dectris-neggia.tar.gz" -C "$INSTALL_DIR"
sudo rm "$INSTALL_DIR/dectris-neggia.tar.gz"

# Add XDS to the PATH
echo "Adding XDS to the PATH..."
export PATH="$INSTALL_DIR:$PATH"
if ! grep -Fxq "export PATH=\"$INSTALL_DIR:\$PATH\"" /etc/bash.bashrc; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> /etc/bash.bashrc
    echo "XDS installation path added to /etc/bash.bashrc"
else
    echo "XDS installation path already exists in /etc/bash.bashrc"
fi

echo "Installation of xds completed! Run 'source etc/bash.bashrc' to update your PATH."
