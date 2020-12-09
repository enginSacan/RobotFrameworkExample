"""This file is created for craeting a tftp server in PC."""
import tftpy
import threading
from robot.api.deco import keyword


server = tftpy.TftpServer('D:/robot_framework/Tftp_Files')

@keyword('TFTP START')
def tftp_start (ip_address):
    server_thread = threading.Thread(target=server.listen,
                                         kwargs={'listenip': ip_address,
                                                 'listenport': 69})
    server_thread.start()

@keyword('TFTP STOP')
def tftp_stop ():
    server.stop(now=False)