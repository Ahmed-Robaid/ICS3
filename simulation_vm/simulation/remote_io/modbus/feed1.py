import socket
import json
from pymodbus.server.asynchronous import StartTcpServer
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.datastore import ModbusSequentialDataBlock, ModbusServerContext, ModbusSlaveContext
from twisted.internet.task import LoopingCall
import logging

# Configure logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.DEBUG)

last_command = -1

def receive_full_message(sock):
    """Receive the full JSON message from the socket."""
    buffer = ""
    while True:
        try:
            data = sock.recv(1024).decode('utf-8')  # Decode using utf-8
            if not data:
                # Connection closed or empty message
                raise ConnectionError("Socket closed or empty response")
            buffer += data
            if '\n' in buffer or '}' in buffer:
                # We have a complete message (delimited by \n or JSON ends with })
                break
        except socket.error as e:
            log.error(f"Socket error: {e}")
            break
    return buffer

def updating_writer(a):
    """Update Modbus context based on simulation data."""
    global last_command
    print('Updating Modbus context...')
    context = a[0]
    slave_id = 0x01  # Slave address
    s = a[1]
    
    # Retrieve current command from Modbus
    current_command = context[slave_id].getValues(16, 1, 1)[0] / 65535.0 * 100.0
    log.debug(f"Current command: {current_command}")
    
    # Send request to simulation via socket (encoded in UTF-8)
    message = {
        "request": "write",
        "data": {
            "inputs": {
                "f1_valve_sp": current_command
            }
        }
    }
    s.sendall((json.dumps(message) + '\n').encode('utf-8'))  # Encode message in UTF-8 and send
    
    # Receive and decode the JSON response
    data = receive_full_message(s)
    try:
        json_data = json.loads(data)  # Decode the received data
        log.debug(f"Received JSON data: {json_data}")
    except json.JSONDecodeError:
        log.error("Failed to decode JSON response")
        return
    
    # Extract values from the JSON response
    valve_pos = int(json_data["state"]["f1_valve_pos"] / 100.0 * 65535)
    flow = int(json_data["outputs"]["f1_flow"] / 500.0 * 65535)
    
    # Clamp values to valid Modbus range
    valve_pos = min(max(valve_pos, 0), 65535)
    flow = min(max(flow, 0), 65535)
    
    # Update Modbus context with the new values
    context[slave_id].setValues(4, 1, [valve_pos, flow])
    log.debug(f"Updated Modbus values: valve_pos={valve_pos}, flow={flow}")

def run_update_server():
    """Run the Modbus server and connect to the simulation."""
    # Initialize the Modbus data store
    store = ModbusSlaveContext(
        di=ModbusSequentialDataBlock(0, list(range(1, 101))),
        co=ModbusSequentialDataBlock(0, list(range(101, 201))),
        hr=ModbusSequentialDataBlock(0, list(range(201, 301))),
        ir=ModbusSequentialDataBlock(0, list(range(301, 401)))
    )
    context = ModbusServerContext(slaves=store, single=True)

    # Initialize the server identity information
    identity = ModbusDeviceIdentification()
    identity.VendorName = 'pymodbus'
    identity.ProductCode = 'PM'
    identity.VendorUrl = 'http://github.com/bashwork/pymodbus/'
    identity.ProductName = 'pymodbus Server'
    identity.ModelName = 'pymodbus Server'
    identity.MajorMinorRevision = '1.0'

    # Connect to the simulation (TCP socket)
    HOST = '127.0.0.1'
    PORT = 55555
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect((HOST, PORT))
        log.info(f"Connected to simulation at {HOST}:{PORT}")
    except socket.error as e:
        log.error(f"Failed to connect to simulation: {e}")
        return

    # Start updating the Modbus context periodically
    time_interval = 1  # Time interval (in seconds) between updates
    loop = LoopingCall(f=updating_writer, a=(context, sock))
    loop.start(time_interval, now=False)  # Delay the first call

    # Start the Modbus TCP server
    StartTcpServer(context, identity=identity, address=("192.168.95.10", 502))

if __name__ == "__main__":
    run_update_server()
