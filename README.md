[![Build Status](https://github.com/xantares/nfc-bindings/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/xantares/nfc-bindings/actions/workflows/build.yml)

nfc-bindings
============

Introduction
------------

The project goal is to provide scripting language bindings for libnfc (http://www.libnfc.org/) through swig.

For now only Python bindings are supported with full docstrings.

Requirements
------------

  * libnfc >= 1.8
  * CMake
  * SWIG
  * Python

Quickstart
----------

    git clone https://github.com/xantares/nfc-bindings.git
    cd nfc-bindings
    cmake -DCMAKE_INSTALL_PREFIX=~/.local .
    make install
    python python/examples/quick_start_example.py

Example
-------

    import nfc
    context = nfc.init()
    pnd = nfc.open(context)
    if pnd is not None:
        if nfc.initiator_init(pnd) == 0:
            print('NFC reader: %s opened' % nfc.device_get_name(pnd))
    nfc.close(pnd)
    nfc.exit(context)

Find more examples in https://github.com/xantares/nfc-bindings/tree/master/python/examples
