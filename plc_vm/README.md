# Programmable Logic Controller (PLC)

The PLC VM is an Ubuntu 22.04 server.

### Instructions

Follow the build instructions at https://github.com/thiagoralves/OpenPLC_v3 with the PLC on a NAT adapter.

git clone https://github.com/thiagoralves/OpenPLC_v3.git

cd OpenPLC_v3

./install.sh linux



Change the network adapter to the host-only network 192.168.95.0/24. Set the static IP address to 192.168.95.2.

Upload the included mbconfig.cfg file through the OpenPLC web interface


