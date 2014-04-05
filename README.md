nfc-bindings
============

Introduction
------------

The project goal is to provide scripting language bindings for libnfc (http://www.libnfc.org/) through swig.
For now only bindings are supported (2.x and 3.x).

Example
-------

    import nfc
    context = nfc.init()
    ret, pnd = nfc.open(context, 0)
    if(nfc.initiator_init(pnd)<0):
        print('NFC reader: %s opened' % nfc.device_get_name(pnd))
    nfc.close(pnd)
    nfc.exit(context)

Installation
------------

    git clone https://github.com/xantares/nfc-bindings.git
    cd nfc-bindings
    cmake -DCMAKE_INSTALL_PREFIX=$PWD/install .
    make install
