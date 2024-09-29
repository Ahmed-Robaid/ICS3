import socket
import json
import asyncio
from pymodbus.server import StartAsyncTcpServer
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.datastore import ModbusSequentialDataBlock, ModbusServerContext, ModbusSlaveContext
from pymodbus.transaction import ModbusRtuFramer, ModbusAsciiFramer

from pymodbus import __version__ as pymodbus_version

# --------------------------------------------------------------------------- #
# define your callback process
# --------------------------------------------------------------------------- #

last_command = -1

async def updating_writer(context, sock):
    global last_command
    print('updating')
    
    slave_id = 0x01  # slave address
    count = 50
    
    current_command = context[slave_id].getValues(16, 1, 1)[0] / 65535.0 * 100.0

    sock.sendall(b'{"request":"write","data":{"inputs":{"f1_valve_sp":' + repr(current_command).encode() + b'}}}\n')

    data = json.loads(sock.recv(1500))
    valve_pos = int(data["state"]["f1_valve_pos"] / 100.0 * 65535)
    flow = int(data["outputs"]["f1_flow"] / 500.0 * 65535)
    print(data)
    if valve_pos > 65535:
        valve_pos = 65535
    elif valve_pos < 0:
        valve_pos = 0
    if flow > 65535:
        flow = 65535
    elif flow < 0:
        flow = 0

    context[slave_id].setValues(4, 1, [valve_pos, flow])

async def run_update_server():
    # ----------------------------------------------------------------------- #
    # initialize your data store
    # ----------------------------------------------------------------------- #

    store = ModbusSlaveContext(
        di=ModbusSequentialDataBlock(0, range(1, 101)),
        co=ModbusSequentialDataBlock(0, range(101, 201)),
        hr=ModbusSequentialDataBlock(0, range(201, 301)),
        ir=ModbusSequentialDataBlock(0, range(301, 401))
    )

    context = ModbusServerContext(slaves=store, single=True)
    #args[context]
    # ----------------------------------------------------------------------- #
    # initialize the server information
    # ----------------------------------------------------------------------- #
    identity = ModbusDeviceIdentification()
    identity.VendorName = 'pymodbus'
    identity.ProductCode = 'PM'
    identity.VendorUrl = 'http://github.com/bashwork/pymodbus/'
    identity.ProductName = 'pymodbus Server'
    identity.ModelName = 'pymodbus Server'
    identity.MajorMinorRevision = pymodbus_version

    # connect to simulation
    HOST = '127.0.0.1'
    PORT = 55555
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((HOST, PORT))

    # ----------------------------------------------------------------------- #
    # run the server you want
    # ----------------------------------------------------------------------- #
    time = 1  # 1 second delay
    loop = asyncio.get_event_loop()
    loop.call_later(time, asyncio.create_task, updating_writer(context, sock))
    await StartAsyncTcpServer(context=context, identity=identity, address=("192.168.168.120", 502))

if __name__ == "__main__":
    asyncio.run(run_update_server())


    sock.sendall(b'{"request":"write","data":{"inputs":{"product_valve_sp":' + repr(current_command).encode() + b'}}}\n')
    sock.sendall(b'{"request":"write","data":{"inputs":{"purge_valve_sp":' + repr(current_command).encode() + b'}}}\n')
