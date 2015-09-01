nfc-bindings
============

Introduction
------------

The project goal is to provide scripting language bindings for libnfc (http://www.libnfc.org/) through swig.

For now only Python bindings are supported (2.x and 3.x), with full docstrings.

Alternative Python bindings are provided by PyNFC (https://github.com/ikelos/pynfc), which is somewhat higher-level, while the API does not seem to be fully covered.

Requirements
------------

  * libnfc = 1.7.1
  * cmake
  * swig
  * python

Install
-------

    git clone https://github.com/xantares/nfc-bindings.git
    cd nfc-bindings
    cmake -DCMAKE_INSTALL_PREFIX=~/.local .
    make install

Example
-------

    from __future__ import print_function
    import nfc
    context = nfc.init()
    pnd = nfc.open(context)
    if pnd is not None:
        if nfc.initiator_init(pnd) < 0:
            print('NFC reader: %s opened' % nfc.device_get_name(pnd))
    nfc.close(pnd)
    nfc.exit(context)

Find more examples in https://github.com/xantares/nfc-bindings/tree/master/python/examples



