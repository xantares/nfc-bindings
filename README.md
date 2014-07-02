nfc-bindings
============

Introduction
------------

The project goal is to provide scripting language bindings for libnfc (http://www.libnfc.org/) through swig.

For now only Python bindings are supported (2.x and 3.x), with full docstrings.

Alternative Python bindings are provided by PyNFC (http://code.google.com/p/pynfc/source/list), which is somewhat higher-level, while the API does not seem to be fully covered.

Example
-------

    import nfc
    context = nfc.init()
    pnd = nfc.open(context, 0)
    if pnd is not None:
        if(nfc.initiator_init(pnd)<0):
            print('NFC reader: %s opened' % nfc.device_get_name(pnd))
    nfc.close(pnd)
    nfc.exit(context)

Find more examples in https://github.com/xantares/nfc-bindings/tree/master/python/examples

Requirements
------------

  - libnfc >= 1.7.0
  - cmake
  - swig
  - python headers

<<<<<<< HEAD
  * libnfc >= 1.7.1
  * cmake
  * swig
  * python
    
=======
>>>>>>> b081ec0e104bd1aa34ac1e6a70400a3fc8b946a6
Build
-----

    git clone https://github.com/xantares/nfc-bindings.git
    cd nfc-bindings
    cmake -DCMAKE_INSTALL_PREFIX=$PWD/install .
    make install
