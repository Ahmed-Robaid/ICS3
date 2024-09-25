FROM ubuntu:22.04

# Update repos and install packages
RUN apt-get update && \
    apt-get install -y libjsoncpp-dev liblapacke-dev python3-pymodbus build-essential apache2 php libapache2-mod-php sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build the app
COPY . /opt/simulation
WORKDIR /opt/simulation/simulation
RUN make

# Set up web visualization
RUN rm /var/www/html/index.html && \
    ln -s /opt/simulation/web_visualization/* /var/www/html

# Start the server
CMD service apache2 start && ./remote_io/modbus/run_all.sh && ./simulation
