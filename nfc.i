/* File: nfc.i */

%module(docstring="Bindings for libnfc") nfc
%feature("autodoc","1");

%{
#include <stdbool.h>

#include "python_wrapping.h"
%}

%include <typemaps.i>
%include <cstring.i>
%rename("%(strip:[nfc_])s") "";

//%typemap(out) uint8_t * %{ $result = toPyBytes($1); %}
//%typemap(argout) uint8_t * %{ $result = toPyBytes($1); %}

//%typemap(out) uint8_t * = char*;

%typemap(out) uint8_t = int;

%typemap(out) uint8_t abtAtqa[2] %{ $result = toPyBytesSize($1, 2); %}
%typemap(out) uint8_t abtUid[10] %{ $result = toPyBytesSize($1, 10); %}
%typemap(out) uint8_t abtAts[254] %{ $result = toPyBytesSize($1, 254); %}









%define nfc_init_doc
"init() -> context


Returns
=======
  context: the initialized nfc context"
%enddef
%feature("autodoc", nfc_init_doc) nfc_init;
//%newobject nfc_init;
%typemap(in,numinputs=0) SWIGTYPE** OUTPUT ($*ltype temp) %{ $1 = &temp; %}
%typemap(argout) SWIGTYPE** OUTPUT %{ $result = SWIG_Python_AppendOutput($result, SWIG_NewPointerObj((void*)*$1,$*descriptor,0)); %}
%apply SWIGTYPE** OUTPUT { nfc_context **context };
    void nfc_init(nfc_context **context);
%clear nfc_context **context;
%typemap(newfree) nfc_context * "nfc_exit($1);";

%define nfc_exit_doc
"exit(context)

Parameter
=========
  context: nfc_context"
%enddef
%feature("autodoc", nfc_exit_doc) nfc_exit;
//%delobject nfc_exit;


%define nfc_open_doc
"open(context, connstring) -> (ret, device)"
%enddef
%feature("autodoc", nfc_open_doc) nfc_open;
//%newobject nfc_open;
%typemap(out) nfc_device * %{
  $result = SWIG_Python_AppendOutput(PyInt_FromLong($1!=NULL?0:-1), SWIG_NewPointerObj((void*)$1,$descriptor,0));
%}
%typemap(newfree) nfc_device * "nfc_close($1);";

%typemap(typecheck,precedence=SWIG_TYPECHECK_INTEGER) const nfc_connstring {
  $1 = checkPyString($input) ||(checkPyInt($input) && (fromPyInt($input)==0))
}
%typemap(in) const nfc_connstring %{
  $1 = 0;
  if(checkPyString($input)) {
    $1 = fromPyString($input);
  }
%}
nfc_device *nfc_open(nfc_context *context, const nfc_connstring connstring);
%clear nfc_device *;


%typemap(typecheck,precedence=SWIG_TYPECHECK_INTEGER) uint8_t * {
  $1 = checkPyBytes($input) ||(checkPyInt($input) && (fromPyInt($input)==0))
}
%typemap(in) uint8_t * %{
  $1 = 0;
  if(checkPyBytes($input)) {
    $1 = fromPyBytes($input);
  }
%}

//%newobject nfc_initiator_select_passive_target;
//%typemap(in,numinputs=0) nfc_target *pnt ($*ltype temp) %{ $1 = &temp; %}
//%typemap(argout) nfc_target *pnt %{ $result = SWIG_Python_AppendOutput($result, SWIG_NewPointerObj(SWIG_as_voidptr($1),$descriptor,SWIG_POINTER_NEW |0)); %}
//int nfc_initiator_select_passive_target(nfc_device *pnd, const nfc_modulation nm, const uint8_t *pbtInitData, const size_t szInitData, nfc_target *pnt);
//%clear nfc_target *pnt;

//%define nfc_close_doc
//"close(device)"
//%enddef
//%feature("autodoc", nfc_close_doc) nfc_close;
//%delobject nfc_close;


%define nfc_initiator_transceive_bytes_doc
"initiator_transceive_bytes(pnd, pbtTx, szTx, timeout) -> (szRxBits, pbtRx)"
%enddef
%feature("autodoc", nfc_initiator_transceive_bytes_doc) nfc_initiator_transceive_bytes;
%typemap(in,numinputs=1) (uint8_t *pbtRx, const size_t szRx) %{ $2 = PyInt_AsLong($input);$1 = (uint8_t *)calloc($2,sizeof(uint8_t)); %}
%typemap(argout) (uint8_t *pbtRx, const size_t szRx) %{ if(result<0) $2=0; $result = SWIG_Python_AppendOutput($result, toPyBytesSize((uint8_t *)$1, $2)); free($1); %}
int nfc_initiator_transceive_bytes(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTx, uint8_t *pbtRx, const size_t szRx, int timeout);


%define nfc_initiator_transceive_bits_doc
"initiator_transceive_bits(pnd, pbtTx, szTxBits, pbtTxPar, szRx) -> (pbtRx, pbtRxPar)"
%enddef
%feature("autodoc", nfc_initiator_transceive_bits_doc) nfc_initiator_transceive_bits;
%apply (uint8_t *pbtRx, const size_t szRx) { (uint8_t *pbtRx, const size_t szTxBits) }; 
int nfc_initiator_transceive_bits(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, const uint8_t *pbtTxPar, uint8_t *pbtRx, const size_t szRx, uint8_t *pbtRxPar);

%define nfc_initiator_transceive_bytes_timed_doc
"initiator_transceive_bytes_timed(pnd, pbtTx, szTx, szRx) -> (szRxBits, pbtRx, cycles)"
%enddef
%feature("autodoc", nfc_initiator_transceive_bytes_timed_doc) nfc_initiator_transceive_bytes_timed;
int nfc_initiator_transceive_bytes_timed(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, uint8_t *pbtRx, const size_t szRx, uint32_t *cycles);


%define nfc_initiator_transceive_bits_timed_doc
"initiator_transceive_bits_timed(pnd, pbtTx, szTxBits, pbtTxPar, szRx) -> (szRxBits, pbtRx, cycles)"
%enddef
%feature("autodoc", nfc_initiator_transceive_bits_timed_doc) nfc_initiator_transceive_bits_timed;
int nfc_initiator_transceive_bits_timed(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, const uint8_t *pbtTxPar, uint8_t *pbtRx, const size_t szRx, uint8_t *pbtRxPar, uint32_t *cycles);

%define nfc_target_receive_bits_doc
"nfc_target_receive_bits(pnd, pbtTx, szRx, pbtRxPar, szRx) -> (szRxBits, pbtRx)"
%enddef
%feature("autodoc", nfc_target_receive_bits_doc) nfc_target_receive_bits;
int nfc_target_receive_bits(nfc_device *pnd, uint8_t *pbtRx, const size_t szRx, uint8_t *pbtRxPar);
%clear (uint8_t *pbtRx, const size_t szRx);


%include nfc/nfc-types.h
%{
#include <nfc/nfc-types.h>
%}

%include nfc/nfc.h
%{
#include <nfc/nfc.h>
%}

%pythoncode %{
__version__ = version()

import sys


def convBytes(pData):
    if sys.version_info[0] < 3:  # python 2
        byt = ord(pData)
    else:
        byt = pData
    return byt

def print_hex(pbtData, szBytes):
    for szPos in range(szBytes):
        sys.stdout.write("%02x  " % convBytes(pbtData[szPos]))
    print('')
    
def print_hex_bits(pbtData, szBits):

    szBytes = divmod(szBits, 8)[0]
    for szPos in range(szBytes):
        sys.stdout.write("%02x  " % convBytes(pbtData[szPos]))
    uRemainder = szBits % 8
    # Print the rest bits
    if uRemainder != 0:
        if (uRemainder < 5):
            sys.stdout.write("%01x (%d bits)" % (convBytes(pbtData[szBytes]), uRemainder))
        else:
            sys.stdout.write("%02x (%d bits)" % (convBytes(pbtData[szBytes]), uRemainder))
      
    print('')

%}
