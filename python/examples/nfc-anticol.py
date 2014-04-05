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
            return False, pbtRx
        if (not quiet_output) and (szRxBits > 0):
            print("Response after %u cycles" % cycles)
        
    else:
        szRxBits, pbtRx = nfc.initiator_transceive_bits(pnd, pbtTx, szTxBits, 0, MAX_FRAME_LEN, 0)
        if szRxBits < 0:
            return False, pbtRx
    
    # Show received answer
    if not quiet_output:
        print('Received bits: ', end='')
        nfc.print_hex_bits(pbtRx, szRxBits)
    
    # Succesful transfer
    return True, pbtRx


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
            return False, pbtRx
        if (not quiet_output) and (szRx > 0):
            print("Response after %u cycles" % cycles)
        
    else:
        szRx, pbtRx = nfc.initiator_transceive_bytes(pnd, pbtTx, szTx, len(abtRx),  0)
        if szRx < 0:
            return False, pbtRx
    
    # Show received answer
    if not quiet_output:
        print('Received bits: ', end='')
        nfc.print_hex(pbtRx, szRx)
    
    # Succesful transfer
    return True, pbtRx



context = nfc.init()
pnd = nfc.open(context)
if pnd is None:
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
    
print("NFC reader:", nfc.device_get_name(pnd), "opened\n")
  
# Send the 7 bits request command specified in ISO 14443A (0x26)
ret, abtRx = transmit_bits(abtReqa, 7)

if not ret:
    print("Error: No tag available")
    nfc.close(pnd)
    nfc.exit(context)
    exit()
  
abtAtqa = abtRx[0:2]

ret, abtRx = transmit_bytes(abtSelectAll, 2)

# Check answer
if (abtRx[0] ^ abtRx[1] ^ abtRx[2] ^ abtRx[3] ^ abtRx[4]) != 0:
    print("WARNING: BCC check failed!")
   
# Save the UID CL1
abtRawUid = abtRx[0:4]
  
# Prepare and send CL1 Select-Command
abtSelectTag[2:7] = abtRx[0:5]
nfc.iso14443a_crc_append(abtSelectTag, 7)
ret, abtRx = transmit_bytes(abtSelectTag, 9)
abtSak = abtRx[0]
  
if szCL == 2:
    # We have to do the anti-collision for cascade level 2

    # Prepare CL2 commands
    abtSelectAll[0] = 0x95

    # Anti-collision
    ret, abtRx = transmit_bytes(abtSelectAll, 2)

    # Check answer
    if (abtRx[0] ^ abtRx[1] ^ abtRx[2] ^ abtRx[3] ^ abtRx[4]) != 0:
        print("WARNING: BCC check failed!")
    

    # Save UID CL2
    abtRawUid[4:8] = abtRx[0:4]

    # Selection
    abtSelectTag[0] = 0x95
    abtSelectTag[2:7] = abtRx[0:5]
    iso14443a_crc_append(abtSelectTag, 7)
    ret, abtRx = transmit_bytes(abtSelectTag, 9)
    abtSak = abtRx[0]

    # Test if we are dealing with a CL3
    if abtSak & nfc.CASCADE_BIT:
      szCL = 3
      # Check answer
      if abtRawUid[0] != 0x88:
          print("WARNING: Cascade bit set but CT != 0x88!")
      


    if szCL == 3:
        # We have to do the anti-collision for cascade level 3

        # Prepare and send CL3 AC-Command
        abtSelectAll[0] = 0x97
        ret, abtRx = transmit_bytes(abtSelectAll, 2)

        # Check answer
        if (abtRx[0] ^ abtRx[1] ^ abtRx[2] ^ abtRx[3] ^ abtRx[4]) != 0:
            print("WARNING: BCC check failed!")
        

        # Save UID CL3
        abtRawUid[8:12]= abtRx[0:4]

        # Prepare and send final Select-Command
        abtSelectTag[0] = 0x97
        memcpy(abtSelectTag + 2, abtRx, 5)
        iso14443a_crc_append(abtSelectTag, 7)
        ret, transmit_bytes(abtSelectTag, 9)
        abtSak = abtRx[0]


    # Request ATS, this only applies to tags that support ISO 14443A-4
    if abtRx[0] & nfc.SAK_FLAG_ATS_SUPPORTED:
        iso_ats_supported = True
    
    if (abtRx[0] & SAK_FLAG_ATS_SUPPORTED) or force_rats:
        iso14443a_crc_append(abtRats, 2)
        ret, abtRx = transmit_bytes(abtRats, 4)
        if (ret):
          abtAts = abtRx
          szAts = len(abtRx)
        
    

# Done, halt the tag now
nfc.iso14443a_crc_append(abtHalt, 2)
abtRx, ret = transmit_bytes(abtHalt, 4)

print("\nFound tag with\n UID: ", end='')
if szCL==1:
    print("%02x%02x%02x%02x" % (abtRawUid[0], abtRawUid[1], abtRawUid[2], abtRawUid[3]))
  
if szCL==2:
  print("%02x%02x%02x" % (abtRawUid[1], abtRawUid[2], abtRawUid[3]))
  print("%02x%02x%02x%02x" % (abtRawUid[4], abtRawUid[5], abtRawUid[6], abtRawUid[7]))

if szCL==3:
  print("%02x%02x%02x" % (abtRawUid[1], abtRawUid[2], abtRawUid[3]))
  print("%02x%02x%02x" % (abtRawUid[5], abtRawUid[6], abtRawUid[7]))
  print("%02x%02x%02x%02x" % (abtRawUid[8], abtRawUid[9], abtRawUid[10], abtRawUid[11]))

print("ATQA: %02x%02x\n SAK: %02x" % (abtAtqa[1], abtAtqa[0], abtSak))
#if (szAts > 1) { // if = 1, it's not actual ATS but error code
#if (force_rats && ! iso_ats_supported) {
  #printf(" RATS forced\n");
#}
#printf(" ATS: ");
#print_hex(abtAts, szAts);
#}
  
  
nfc.close(pnd)
nfc.exit(context)
    