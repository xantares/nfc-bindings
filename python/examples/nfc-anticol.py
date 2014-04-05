#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Generates one ISO14443-A anti-collision process "by-hand"
"""

from __future__ import print_function
import nfc

MAX_FRAME_LEN = 264

abtRawUid = bytes(12)
abtAtqa = bytes(2)
abtAts = bytes(MAX_FRAME_LEN)
szAts = 0
szCL = 1

quiet_output = False
force_rats = False
timed = False
iso_ats_supported = False

# ISO14443A Anti-Collision Commands
abtReqa = bytearray([0x26])
abtSelectAll = bytearray([0x93, 0x20])
abtSelectTag = bytearray([0x93, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
abtRats = bytearray([0xe0, 0x50, 0x00, 0x00])
abtHalt = bytearray([0x50, 0x00, 0x00, 0x00])

CASCADE_BIT = 0x04


def transmit_bits(pbtTx, szTxBits):
  
    cycles = 0
    # Show transmitted command
    if not quiet_output:
        print('Sent bits:     ', end='')
        nfc.print_hex_bits(pbtTx, szTxBits)
    
    # Transmit the bit frame command, we don't use the arbitrary parity feature
    if timed:
        szRxBits, pbtRx, cycles = nfc.initiator_transceive_bits_timed(pnd, pbtTx, szTxBits, 0, MAX_FRAME_LEN, 0 )
        if szRxBits < 0:
            return False
        if (not quiet_output) and (szRxBits > 0):
            print("Response after %u cycles" % cycles)
        
    else:
        szRxBits, pbtRx = nfc.initiator_transceive_bits(pnd, pbtTx, szTxBits, 0, MAX_FRAME_LEN, 0)
        if szRxBits < 0:
            return False
    
    # Show received answer
    if not quiet_output:
        print('Received bits: ', end='')
        nfc.print_hex_bits(pbtRx, szRxBits)
    
    # Succesful transfer
    return pbtRx


def transmit_bytes(pbtTx, szTx):
  
    cycles = 0
    # Show transmitted command
    if not quiet_output:
        print('Sent bits:     ', end='')
        nfc.print_hex(pbtTx, szTx)
    
    # Transmit the bit frame command, we don't use the arbitrary parity feature
    if timed:
        szRx, pbtRx, cycles = nfc.initiator_transceive_bytes_timed(pnd, pbtTx, szTx, 0, abtRx, len(abtRx), 0 )
        if szRx < 0:
            return False
        if (not quiet_output) and (szRx > 0):
            print("Response after %u cycles" % cycles)
        
    else:
        szRx, pbtRx = nfc.initiator_transceive_bytes(pnd, pbtTx, szTx, len(abtRx),  0)
        if szRx < 0:
            return False
    
    # Show received answer
    if not quiet_output:
        print('Received bits: ', end='')
        nfc.print_hex(pbtRx, szRx)
    
    # Succesful transfer
    return pbtRx



context = nfc.init()
ret, pnd = nfc.open(context, 0)
if ret < 0:
    print('ERROR: Unable to open NFC device.')
    nfc.exit(context)
    exit()
    
if(nfc.initiator_init(pnd)<0):
    nfc.perror(pnd, "nfc_initiator_init")
    nfc.close(pnd)
    nfc.exit(context)
    exit()
    
    
if (nfc.device_set_property_bool(pnd, nfc.NP_HANDLE_CRC, False) < 0):
    nfc.perror(pnd, "nfc_device_set_property_bool")
    nfc.close(pnd)
    nfc.exit(context)
    exit()
  
    
if (nfc.device_set_property_bool(pnd, nfc.NP_EASY_FRAMING, False) < 0):
    nfc.perror(pnd, "nfc_device_set_property_bool")
    nfc.close(pnd)
    nfc.exit(context)
    exit()
    
        
if (nfc.device_set_property_bool(pnd, nfc.NP_AUTO_ISO14443_4, False) < 0):
    nfc.perror(pnd, "nfc_device_set_property_bool")
    nfc.close(pnd)
    nfc.exit(context)
    exit()
    
print("NFC reader:", nfc.device_get_name(pnd), "opened")

# Send the 7 bits request command specified in ISO 14443A (0x26)
abtRx = transmit_bits(abtReqa, 7)

  
abtAtqa = abtRx[0:2]

abtRx = transmit_bytes(abtSelectAll, 2)

# Check answer
if (abtRx[0] ^ abtRx[1] ^ abtRx[2] ^ abtRx[3] ^ abtRx[4]) != 0:
    print("WARNING: BCC check failed!")
  
nfc.close(pnd)
nfc.exit(context)
    