#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Quick start example that presents how to use libnfc
"""

from __future__ import print_function
import nfc
import sys

def print_hex(pbtData, szBytes):
    for szPos in range(szBytes):
        if sys.version_info[0] < 3:  # python 2
            byt = ord(pbtData[szPos])
        else:
            byt = pbtData[szPos]
        print("%02x  " % byt, end="")
    print('')

print('Version: ', nfc.__version__)

context = nfc.init()
ret, pnd = nfc.open(context, 0)
if ret < 0:
    print('ERROR: Unable to open NFC device.')
    exit() 
    
if(nfc.initiator_init(pnd)<0):
    nfc.perror(pnd, "nfc_initiator_init")
    print('ERROR: Unable to init NFC device.')
    exit()
    
print('NFC reader: %s opened' % nfc.device_get_name(pnd))

nmMifare = nfc.modulation()
nmMifare.nmt = nfc.NMT_ISO14443A
nmMifare.nbr = nfc.NBR_106

nt = nfc.target()
ret = nfc.initiator_select_passive_target(pnd, nmMifare, 0, 0, nt)

print('The following (NFC) ISO14443A tag was found:')
print('    ATQA (SENS_RES): ', end='')
print_hex(nt.nti.nai.abtAtqa, 2)
id = 1
if(nt.nti.nai.abtUid[0]==8):
    id = 3
print('       UID (NFCID%d): ' % id , end='')
print_hex(nt.nti.nai.abtUid, nt.nti.nai.szUidLen)
print('      SAK (SEL_RES): ', end='')
print(nt.nti.nai.btSak)
if (nt.nti.nai.szAtsLen):
    print('          ATS (ATR): ', end='')
    print_hex(nt.nti.nai.abtAts, nt.nti.nai.szAtsLen)
    