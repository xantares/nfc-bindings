#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Lists the first target present of each found device
"""

from __future__ import print_function
import nfc
import sys

verbose = False
mask = 0xff
max_device_count = 16
max_target_count = 16


context = nfc.init()

# Display libnfc version
print("%s uses libnfc %s" %( sys.argv[0], nfc.__version__))

# TODO
connstrings = nfc.list_devices(context, max_device_count)
szDeviceFound = len(connstrings)

if szDeviceFound == 0:
    print("No NFC device found.")

for i in range(szDeviceFound):
    pnd = nfc.open(context, connstrings[i]);
    if pnd is None:
        continue

    if(nfc.initiator_init(pnd)<0):
        nfc.perror(pnd, "nfc_initiator_init")
        nfc.close(pnd)
        nfc.exit(context)
        exit()
        
    print("NFC reader:", nfc.device_get_name(pnd), "opened")   

    nm = nfc.modulation()
    if mask & 0x1:
        nm.nmt = nfc.NMT_ISO14443A
        nm.nbr = nfc.NBR_106
        # List ISO14443A targets
        res, ant = nfc.initiator_list_passive_targets(pnd, nm, max_target_count)
        if (res >= 0):
            if (verbose or (res > 0)):
                print(res, 'ISO14443A passive target(s) found')
            
            for n in range(res):
                nfc.print_nfc_target(ant[n], verbose)
                print('')






    nfc.close(pnd)
nfc.exit(context)
    