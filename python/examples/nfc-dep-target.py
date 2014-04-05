#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Turns the NFC device into a D.E.P. target (see NFCIP-1)
"""

from __future__ import print_function
import nfc


MAX_FRAME_LEN = 264


def stop_dep_communication(pnd, context):
    if pnd is None:
        nfc.abort_command(pnd)
    else:
        nfc.exit(context)
        exit()
    
    
abtTx = b'Hello Mars!'

context = nfc.init()
if context is None:
    print("Unable to init libnfc")
    exit()
  
MAX_DEVICE_COUNT = 2

connstrings = nfc.list_devices(context, MAX_DEVICE_COUNT)
szDeviceFound = len(connstrings)

if szDeviceFound == 1:
    pnd = nfc.open(context, connstrings[0])
elif szDeviceFound > 1:
    pnd = nfc.open(context, connstrings[1])
else:
    print("No device found.")
    nfc.exit(context)
    exit()
  
nt = nfc.target()
nt.nm.nmt = nfc.NMT_DEP
nt.nm.nbr = nfc.NBR_UNDEFINED
nt.nti.ndi.abtNFCID3 = bytearray([0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xff, 0x00, 0x00])
nt.nti.ndi.szGB = 4
nt.nti.ndi.abtGB = bytearray([0x12, 0x34, 0x56, 0x78])
nt.nti.ndi.ndm = nfc.NDM_UNDEFINED
nt.nti.ndi.btDID = 0x00
nt.nti.ndi.btBS = 0x00
nt.nti.ndi.btBR = 0x00
nt.nti.ndi.btTO = 0x00
nt.nti.ndi.btPP = 0x01

if pnd is None:
    print("Unable to open NFC device.")
    nfc.exit(context)
    exit()

print("NFC device: %s opened" % nfc.device_get_name(pnd))

#signal(SIGINT, stop_dep_communication);

print("NFC device will now act as: ")
#print_nfc_target(&nt, false)

print("Waiting for initiator request...")
abtRx = nfc.target_init(pnd, nt, MAX_FRAME_LEN, 0)
szRx = len(abtRx)
if szRx < 0:
    nfc.perror(pnd, "nfc_target_init")
    nfc.close(pnd)
    nfc.exit(context)
    exit()


print("Initiator request received. Waiting for data...\n")
abtRx = nfc.target_receive_bytes(pnd, MAX_FRAME_LEN, 0)
szRx = len(abtRx)
if szRx < 0:
    nfc.perror(pnd, "nfc_target_receive_bytes")
    nfc.close(pnd)
    nfc.exit(context)
    exit()

#abtRx[szRx] = '\0'
print("Received: %s\n", abtRx)

print("Sending: %s\n", abtTx);
if nfc.target_send_bytes(pnd, abtTx, len(abtTx), 0) < 0:
    nfc.perror(pnd, "nfc_target_send_bytes")
    nfc.close(pnd)
    nfc.exit(context)
    exit()

print("Data sent.")

nfc.close(pnd)
nfc.exit(context)


