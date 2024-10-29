import socket
import json
import feed1
import feed2
import purge
import product
import tank
import analyzer

import logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.DEBUG)

feed1.run_update_server()
feed2.run_update_server()
purge.run_update_server()
product.run_update_server()
tank.run_update_server()
analyzer.run_update_server()