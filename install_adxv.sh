!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Set non-interactive mode for installation
export DEBIAN_FRONTEND=noninteractive

ADXV_URL=https://www.scripps.edu/tainer/arvai/adxv/adxv_1.9.15/adxv.x86_64Debian10

sudo wget -q --show-progress "$ADXV_URL" -O /usr/local/bin/adxv.x86_64Debian10
sudo mv /usr/local/bin/adxv.x86_64Debian10 /usr/local/bin/adxv
sudo chmod +x /usr/local/bin/adxv

sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
sudo sysctl -p

echo "Finished installing adxv!"
