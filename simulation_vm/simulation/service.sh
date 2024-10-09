#!/bin/bash

# Define the service file path
SERVICE_FILE="/etc/systemd/system/simulation.service"
interface_file="/etc/network/interfaces"

# Create the systemd service file
cat <<EOL > $SERVICE_FILE
[Unit]
Description=Start Simulation on Boot

[Service]
Type=forking
ExecStart=/bin/bash /home/$(logname)/ICS/simulation_vm/simulation/remote_io/modbus/run_all.sh

[Install]
WantedBy=multi-user.target
EOL

# Reload the systemd daemon to recognize the new service
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable simulation.service


cat <<EOL > $interface_file
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto enp0s3:0
iface enp0s3:0 inet static
address 192.168.95.10
netmask 255.255.255.0
gateway 192.168.95.1

auto enp0s3:1
iface enp0s3:1 inet static
address 192.168.95.11
netmask 255.255.255.0

auto enp0s3:2
iface enp0s3:2 inet static
address 192.168.95.12
netmask 255.255.255.0

auto enp0s3:3
iface enp0s3:3 inet static
address 192.168.95.13
netmask 255.255.255.0

auto enp0s3:4
iface enp0s3:4 inet static
address 192.168.95.14
netmask 255.255.255.0

auto enp0s3:5
iface enp0s3:5 inet static
address 192.168.95.15
netmask 255.255.255.0
EOL

systemctl restart networking.service

echo "Dont Forget To Change NIC To Host_Only"
sleep 3
