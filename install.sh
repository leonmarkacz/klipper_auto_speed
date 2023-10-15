#!/bin/bash
# Automatically link auto_speed to Klipper
#
# Copyright (C) 2023 Anonoei <dev@anonoei.com>
#
# This file may be distributed under the terms of the MIT license.

# Constants
KLIPPER_PATH="${HOME}/klipper"
SYSTEMDDIR="/etc/systemd/system"
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KLIPPER_SERVICE="klipper.service"

# Verify we're not running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: This script must not run as root."
    exit 1
fi

# Check if Klipper is installed
if ! sudo systemctl list-units --full -all -t service --no-legend | grep -Fq "$KLIPPER_SERVICE"; then
    echo "Error: Klipper service not found. Please install Klipper first."
    exit 1
fi

# Link auto_speed to Klipper
echo "Linking auto_speed to Klipper..."
ln -sf "${SRCDIR}/auto_speed.py" "${KLIPPER_PATH}/klippy/extras/auto_speed.py"

# Restart Klipper
echo "Restarting Klipper..."
sudo systemctl restart klipper
