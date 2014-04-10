#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Lists the first target present of each found device
"""

from __future__ import print_function
import nfc
import sys

context = nfc.init()
pnd = nfc.open(context)
if pnd is None:
    print('ERROR: Unable to open NFC device.')
    nfc.exit(context)
    exit()

# Display libnfc version
print("%s uses libnfc %s" %( sys.argv[0], nfc.__version__))

# TODO



nfc.close(pnd)
nfc.exit(context)
    