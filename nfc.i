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

%apply int { size_t };

%typemap(in) uint8_t = int;
%typemap(out) uint8_t = int;

%define uint8_t_static_out_helper(name, size)
%typemap(out) uint8_t name[size] { $result = toPyBytesSize($1, size); }
%enddef

uint8_t_static_out_helper(abtNFCID3, 10)
uint8_t_static_out_helper(abtGB, 10)

uint8_t_static_out_helper(abtAtqa, 2)
uint8_t_static_out_helper(abtUid, 10)
uint8_t_static_out_helper(abtAts, 254)

%define uint8_t_static_in_helper(name, size)
%typemap(in) uint8_t name[size] %{
int len = PySequence_Size($input);
uint8_t * vs = fromPyBytes($input);
int max_len = size;
if (len <size)
    max_len = len;
if (vs) {
  int i;
  for (i = 0; i < max_len; ++i) {
    $1[i] = vs[i];
  }       
}
%}
%enddef

uint8_t_static_in_helper(abtNFCID3, 10)
uint8_t_static_in_helper(abtGB, 48)

%typemap(typecheck,precedence=SWIG_TYPECHECK_INTEGER) uint8_t * {
  $1 = checkPyBytes($input) ||(checkPyInt($input) && (fromPyInt($input)==0))
}
%typemap(in) uint8_t * %{
  $1 = 0;
  if(checkPyBytes($input)) {
    $1 = fromPyBytes($input);
  }
%}




%define nfc_init_doc
"init() -> context

Initialize libnfc. This function must be called before calling any other libnfc function. 

Returns
-------
context : nfc_context
    Output location for nfc_context"
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

Deinitialize libnfc. Should be called after closing all open devices and before your application terminates. 

Parameters
----------
context : nfc_context
    Output location for nfc_context"
%enddef
%feature("autodoc", nfc_exit_doc) nfc_exit;
//%delobject nfc_exit;
void nfc_exit(nfc_context *context);




%define nfc_open_doc
"open(context, connstring=0) -> pnd

Open a NFC device. 

Parameters
----------
context : nfc_context
    The context to operate on. 
connstring : string
    The device connection string if specific device is wanted, 0 otherwise 
  
Returns
-------
pnd : nfc_device
    device if successfull, else None"
%enddef
%feature("autodoc", nfc_open_doc) nfc_open;
//%newobject nfc_open;
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
%typemap(default) const nfc_connstring {$1 = 0;}
nfc_device *nfc_open(nfc_context *context, const nfc_connstring connstring);
%clear nfc_device *;




%define nfc_close_doc
"close(pnd)

Close from a NFC device. 

Parameters
----------
pnd : nfc_device
    device that represents the currently used device
"
%enddef
%feature("autodoc", nfc_close_doc) nfc_close;
void nfc_close(nfc_device *pnd);
//%delobject nfc_close;




%define nfc_abort_command_doc
"abort_command(pnd) -> ret

Abort current running command.

Parameters
----------
pnd : nfc_device
    device that represents the currently used device
  
Returns
-------
ret : int
    Returns 0 on success, otherwise returns libnfc's error code.
"
%enddef
%feature("autodoc", nfc_abort_command_doc) nfc_abort_command;
int nfc_abort_command(nfc_device *pnd);




%define nfc_list_devices_doc
"list_devices(context, connstrings_len) -> connstrings

Scan for discoverable supported devices (ie. only available for some drivers) 

Parameters
----------
context : nfc_context
    The context
connstrings_len : int
    size of the connstrings array
  
Returns
-------
connstrings : array of nfc_connstring
    devices list
"
%enddef
%feature("autodoc", nfc_list_devices_doc) nfc_list_devices;
%apply SWIGTYPE** OUTPUT { nfc_connstring connstrings[] };
%typemap(in,numinputs=1) (nfc_connstring connstrings[], size_t connstrings_len) %{ $2 = PyInt_AsLong($input);$1 = (nfc_connstring *)calloc($2,sizeof(nfc_connstring)); %}
%typemap(argout) (nfc_connstring connstrings[], size_t connstrings_len) %{
  PyObject * connstrings = PyList_New(result);
  size_t i;
  for(i = 0; i < result; ++i) {
    PyObject * connstring = toPyString($1[i]);
    PyList_SetItem( connstrings, i, connstring );
  }
  free($1);
  $result = connstrings;
%}
size_t nfc_list_devices(nfc_context *context, nfc_connstring connstrings[], size_t connstrings_len);




%define nfc_idle_doc
"idle(pnd)

Turn NFC device in idle mode. 

Parameters
----------
pnd : nfc_device
    currently used device
"
%enddef
%feature("autodoc", nfc_idle_doc) nfc_idle;
int nfc_idle(nfc_device *pnd);




%define initiator_init_doc
"Initialize NFC device as initiator (reader)

Parameters
----------
pnd : nfc_device
    currently used device
"
%enddef
int nfc_initiator_init(nfc_device *pnd);




%define nfc_initiator_nfc_init_secure_element_doc
"initiator_init_secure_element(pnd)

Initialize NFC device as initiator with its secure element initiator (reader)  

Parameters
----------
pnd : nfc_device
    currently used device"
%enddef
%feature("autodoc", nfc_initiator_nfc_init_secure_element_doc) nfc_initiator_init_secure_element;
int nfc_initiator_init_secure_element(nfc_device *pnd);




%define nfc_initiator_select_passive_target_doc
"initiator_select_passive_target(pnd, nm, pbtInitData, szInitData, pnt) -> ret

Initialize NFC device as initiator with its secure element initiator (reader)  

Parameters
----------
pnd : nfc_device
    currently used device
nm : nfc_modulation
    desired modulation  
pbtInitData : bytearray
    data
szInitData : int
    data size
pnt : nfc_target 
    target
Returns
-------
ret : int
    libnfc's error code
"
%enddef
%feature("autodoc", nfc_initiator_select_passive_target_doc) nfc_initiator_select_passive_target;
int nfc_initiator_select_passive_target(nfc_device *pnd, const nfc_modulation nm, const uint8_t *pbtInitData, const size_t szInitData, nfc_target *pnt);



%define nfc_initiator_list_passive_targets_doc
"initiator_list_passive_targets(pnd, nm, szTargets) -> (ret, ant)

List passive or emulated tags.

Parameters
----------
pnd : nfc_device
    currently used device
nm : nfc_modulation
    desired modulation 
szTargets : int
    size of ant (will be the max targets listed)
  
Returns
-------
ret : int
    number of targets found on success, otherwise returns libnfc's error code (negative value)
ant : array of nfc_target
    will be filled with targets info 
"
%enddef
%feature("autodoc", nfc_initiator_list_passive_targets_doc) nfc_initiator_list_passive_targets;
%apply SWIGTYPE** OUTPUT { nfc_target ant[] };
%typemap(in,numinputs=1) (nfc_target ant[], const size_t szTargets) %{ $2 = PyInt_AsLong($input);$1 = (nfc_target *)calloc($2,sizeof(nfc_target)); %}
%typemap(argout) (nfc_target ant[], const size_t szTargets) %{
  PyObject * ant = PyList_New(result);
  size_t i;
  for(i = 0; i < result; ++i) {
    PyObject * target = SWIG_NewPointerObj((void*)&($1[i]),$descriptor,0);
    PyList_SetItem( ant, i, target );
  }
  $result = SWIG_Python_AppendOutput($result, ant);
%}
int nfc_initiator_list_passive_targets(nfc_device *pnd, const nfc_modulation nm, nfc_target ant[], const size_t szTargets);




%define nfc_initiator_poll_target_doc
"initiator_poll_target(pnd, pnmTargetTypes, szTargets, uiPollNr, uiPeriod) -> (ret, pnt)

Polling for NFC targets.

Parameters
----------
pnd : nfc_device
    currently used device
pnmTargetTypes : nfc_modulation
    desired modulations
szTargets : int
    size of pnmModulations
uiPollNr : int
    specifies the number of polling (0x01 - 0xFE: 1 up to 254 polling, 0xFF: Endless polling) 
uiPeriod : int
    indicates the polling period in units of 150 ms (0x01 - 0x0F: 150ms - 2.25s) 
  
Returns
-------
ret : int
    polled targets count, otherwise returns libnfc's error code (negative value)
pnt : nfc_target
    (over)writable struct 
"
%enddef
%feature("autodoc", nfc_initiator_poll_target_doc) nfc_initiator_poll_target;
int nfc_initiator_poll_target(nfc_device *pnd, const nfc_modulation *pnmTargetTypes, const size_t szTargetTypes, const uint8_t uiPollNr, const uint8_t uiPeriod, nfc_target *pnt);




%define nfc_initiator_select_dep_target_doc
"initiator_select_dep_target(pnd, ndm, nbr, pndiInitiator, timeout) -> (ret, pnt)

Select a target and request active or passive mode for D.E.P. (Data Exchange Protocol)

Parameters
----------
pnd : nfc_device
    currently used device
ndm : nfc_dep_mode
    desired D.E.P. mode (NDM_ACTIVE or NDM_PASSIVE for active, respectively passive mode) 
nbr : nfc_baud_rate
    desired baud rate 
pndiInitiator : nfc_dep_info
    contains NFCID3 and General Bytes to set to the initiator device (optionnal, can be NULL)
timeout : int
    timeout in milliseconds
  
Returns
-------
ret : int
    selected D.E.P targets count on success, otherwise returns libnfc's error code (negative value).
pnt : nfc_target 
    (over)writable struct 
"
%enddef
%feature("autodoc", nfc_initiator_select_dep_target_doc) nfc_initiator_select_dep_target;
int nfc_initiator_select_dep_target(nfc_device *pnd, const nfc_dep_mode ndm, const nfc_baud_rate nbr, const nfc_dep_info *pndiInitiator, nfc_target *pnt, const int timeout);




%define nfc_initiator_poll_dep_target_doc
"initiator_poll_dep_target_doc(pnd, ndm, nbr, pndiInitiator, timeout) -> (ret, pnt)

Poll a target and request active or passive mode for D.E.P. (Data Exchange Protocol)

Parameters
----------
pnd : nfc_device
    currently used device
ndm :
    desired D.E.P. mode (NDM_ACTIVE or NDM_PASSIVE for active, respectively passive mode) 
nbr : 
    desired baud rate 
pndiInitiator : nfc_dep_info
    contains NFCID3 and General Bytes to set to the initiator device (optionnal, can be NULL)
timeout : int
    timeout in milliseconds
  
Returns
-------
ret : int
    selected D.E.P targets count on success, otherwise returns libnfc's error code (negative value).
pnt :  nfc_target
    where target information will be put. 
"
%enddef
%feature("autodoc", nfc_initiator_poll_dep_target_doc) nfc_initiator_poll_dep_target;
int nfc_initiator_poll_dep_target(nfc_device *pnd, const nfc_dep_mode ndm, const nfc_baud_rate nbr, const nfc_dep_info *pndiInitiator, nfc_target *pnt, const int timeout);





%define nfc_initiator_deselect_target_doc
"initiator_deselect_target(pnd) -> ret

Parameters
----------
pnd : nfc_device
    represents the currently used device
  
Returns
-------
ret : int
    0 on success, otherwise returns libnfc's error code (negative value).
"
%enddef
%feature("autodoc", nfc_initiator_deselect_target_doc) nfc_initiator_deselect_target;
int nfc_initiator_deselect_target(nfc_device *pnd);




%define nfc_initiator_transceive_bytes_doc
"initiator_transceive_bytes(pnd, pbtTx, szTx, timeout) -> (ret, pbtRx)

Send data to target then retrieve data from target.

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    contains a byte array of the frame that needs to be transmitted.
szTx : int
    contains the length in bytes.
szRx : int
    size of pbtRx (Will return NFC_EOVFLOW if RX exceeds this size)
timeout : int
    timeout in milliseconds

Returns
-------
ret : int
    received bytes count on success, otherwise returns libnfc's error code
pbtRx : bytes
    response from the target
"
%enddef
%feature("autodoc", nfc_initiator_transceive_bytes_doc) nfc_initiator_transceive_bytes;
%typemap(in,numinputs=1) (uint8_t *pbtRx, const size_t szRx) %{ $2 = PyInt_AsLong($input);$1 = (uint8_t *)calloc($2,sizeof(uint8_t)); %}
%typemap(argout) (uint8_t *pbtRx, const size_t szRx) %{ if(result<0) $2=0; $result = SWIG_Python_AppendOutput($result, toPyBytesSize((uint8_t *)$1, $2)); free($1); %}
int nfc_initiator_transceive_bytes(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTx, uint8_t *pbtRx, const size_t szRx, int timeout);




%define nfc_initiator_transceive_bits_doc
"initiator_transceive_bits(pnd, pbtTx, szTxBits, pbtTxPar, szRx) -> (ret, pbtRx, pbtRxPar)

Transceive raw bit-frames to a target.

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    contains a byte array of the frame that needs to be transmitted.
szTxBits : int
    contains the length in bits
pbtTxPar : bytes
    contains a byte array of the corresponding parity bits needed to send per byte.
szRx : int
    size of pbtRx (Will return NFC_EOVFLOW if RX exceeds this size)

Returns
-------
ret : int
    received bits count on success, otherwise returns libnfc's error code
pbtRx : bytes
    response from the target
pbtRxPar : bytes
    parameter contains a byte array of the corresponding parity bits
"
%enddef
%feature("autodoc", nfc_initiator_transceive_bits_doc) nfc_initiator_transceive_bits;
%apply (uint8_t *pbtRx, const size_t szRx) { (uint8_t *pbtRx, const size_t szTxBits) }; 
int nfc_initiator_transceive_bits(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, const uint8_t *pbtTxPar, uint8_t *pbtRx, const size_t szRx, uint8_t *pbtRxPar);


%define nfc_initiator_transceive_bytes_timed_doc
"initiator_transceive_bytes_timed(pnd, pbtTx, szTx, szRx) -> (ret, pbtRx, cycles)

Send data to target then retrieve data from target. 

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    contains a byte array of the frame that needs to be transmitted
szTx : int
    contains the length in bytes
pbtTxPar : bytes
    contains a byte array of the corresponding parity bits needed to send per byte.
szRx : int
    size of pbtRx (Will return NFC_EOVFLOW if RX exceeds this size)

Returns
-------
ret : int
    received bytes count on success, otherwise returns libnfc's error code
pbtRx : bytes
    response from the target
cycles : int
    number of cycles
"
%enddef
%feature("autodoc", nfc_initiator_transceive_bytes_timed_doc) nfc_initiator_transceive_bytes_timed;
%typemap(in,numinputs=0) uint32_t *cycles ($*ltype temp) %{ temp = 0; $1 = &temp; %}
%typemap(argout) uint32_t *cycles %{ $result = SWIG_Python_AppendOutput($result, SWIG_NewPointerObj((void*)*$1,$*descriptor,0)); %}
int nfc_initiator_transceive_bytes_timed(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, uint8_t *pbtRx, const size_t szRx, uint32_t *cycles);


%define nfc_initiator_transceive_bits_timed_doc
"initiator_transceive_bits_timed(pnd, pbtTx, szTxBits, pbtTxPar, szRx) -> (ret, pbtRx, cycles)

Transceive raw bit-frames to a target.

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    contains a byte array of the frame that needs to be transmitted.
szTxBits : int
    contains the length in bits
pbtTxPar : bytes
    contains a byte array of the corresponding parity bits needed to send per byte.
szRx : int
    size of pbtRx (Will return NFC_EOVFLOW if RX exceeds this size)

Returns
-------
ret : int
    received bits count on success, otherwise returns libnfc's error code
pbtRx : bytes
    response from the target
cycles : int
    number of cycles
"
%enddef
%feature("autodoc", nfc_initiator_transceive_bits_timed_doc) nfc_initiator_transceive_bits_timed;
int nfc_initiator_transceive_bits_timed(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, const uint8_t *pbtTxPar, uint8_t *pbtRx, const size_t szRx, uint8_t *pbtRxPar, uint32_t *cycles);




%define nfc_target_init_doc
"target_init(pnd, pnt, timeout) -> (ret, pbtRx)

Initialize NFC device as an emulated tag.

Parameters
----------
pnd : nfc_device
    currently used device
pnt : nfc_target
    wanted emulated target
timeout : int
    timeout in milliseconds
  
Returns
-------
ret : int
    received bits count on success, otherwise returns libnfc's error code
pbtRx : bytes
    response from the target
"
%enddef
%feature("autodoc", nfc_target_init_doc) nfc_target_init;
int nfc_target_init(nfc_device *pnd, nfc_target *pnt, uint8_t *pbtRx, const size_t szRx, int timeout);



%define nfc_target_send_bytes_doc
"target_send_bytes(pnd, pbtTx, timeout) -> ret

Send bytes and APDU frames.

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    Tx buffer 
timeout : int
    timeout in milliseconds
  
Returns
-------
ret : int
    sent bytes count on success, otherwise returns libnfc's error code
"
%enddef
%feature("autodoc", nfc_target_send_bytes_doc) nfc_target_send_bytes;
int nfc_target_send_bytes(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTx, int timeout);



%define nfc_target_receive_bytes_doc
"target_receive_bytes(pnd, szRx, timeout) -> (ret, pbtTx)

Receive bytes and APDU frames.

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    Tx buffer 
szRx : int
    size of Rx buffer
timeout : int
    timeout in milliseconds
  
Returns
-------
ret : int
    received bytes count on success, otherwise returns libnfc's error code
pbtTx : bytes
    Rx buffer 
"
%enddef
%feature("autodoc", nfc_target_receive_bytes_doc) nfc_target_receive_bytes;
int nfc_target_receive_bytes(nfc_device *pnd, uint8_t *pbtRx, const size_t szRx, int timeout);




%define nfc_target_send_bits_doc
"target_send_bits(pnd, pbtTx, timeout) -> ret

Send raw bit-frames.

Parameters
----------
pnd : nfc_device
    currently used device
pbtTx : bytes
    Tx buffer 
pbtTxPar : bytes
    a byte array of the corresponding parity bits
  
Returns
-------
ret : int
    sent bits count on success, otherwise returns libnfc's error code
"
%enddef
%feature("autodoc", nfc_target_send_bytes_doc) nfc_target_send_bits;
int nfc_target_send_bits(nfc_device *pnd, const uint8_t *pbtTx, const size_t szTxBits, const uint8_t *pbtTxPar);




%define nfc_target_receive_bits_doc
"target_receive_bits(pnd, szRx) -> (ret, pbtRx, pbtRxPar)

Receive bit-frames.

Parameters
----------
pnd : nfc_device
    currently used device
szRx : int
    size of Rx buffer
  
Returns
-------
ret : int
    received bytes count on success, otherwise returns libnfc's error code
pbtTx : bytes
    Rx buffer
pbtRxPar : bytes
    parameter contains a byte array of the corresponding parity bits

"
%enddef
%feature("autodoc", nfc_target_receive_bits_doc) nfc_target_receive_bits;
int nfc_target_receive_bits(nfc_device *pnd, uint8_t *pbtRx, const size_t szRx, uint8_t *pbtRxPar);




%define nfc_strerror_doc
"strerror(pnd) -> error

Return the last error string.

Parameters
----------
pnd : nfc_device
    the currently used device
  
Returns
-------
error : string
    error string  
"
%enddef
%feature("autodoc", nfc_strerror_doc) nfc_strerror;
const char *nfc_strerror(const nfc_device *pnd);




%define nfc_strerror_r_doc
"strerror_r(pnd, buf, buflen) -> ret

Renders the last error in buf for a maximum size of buflen chars. 

Parameters
---------
pnd : nfc_device
    currently used device
buf : string
    a string that contains the last error
buflen : int
    size of buffer 

Returns
-------
ret : int
    0 upon success
"
%enddef
%feature("autodoc", nfc_strerror_r_doc) nfc_strerror_r;
int nfc_strerror_r(const nfc_device *pnd, char *buf, size_t buflen);




%define nfc_perror_doc
"perror(pnd, s)

Display the last error occured on a nfc_device. 

Parameters
---------
pnd : nfc_device
    currently used device
s : string 
    a string

"
%enddef
%feature("autodoc", nfc_perror_doc) nfc_perror;
void nfc_perror(const nfc_device *pnd, const char *s);





%define nfc_device_get_last_error_doc
"device_get_last_error(pnd) -> ret

Returns last error occured on a nfc_device. 

Parameters
---------
pnd : nfc_device
    currently used device
  
Returns
-------
ret : int
    represents libnfc's error code.
"
%enddef
%feature("autodoc", nfc_device_get_last_error_doc) nfc_device_get_last_error;
int nfc_device_get_last_error(const nfc_device *pnd);




%define nfc_device_get_name_doc
"device_get_name(pnd) -> name

Returns the device name. 

Parameters
----------
pnd : nfc_device
    currently used device
  
Returns
-------
name : string
    device name
"
%enddef
%feature("autodoc", nfc_device_get_name_doc) nfc_device_get_name;
const char *nfc_device_get_name(nfc_device *pnd);




%define nfc_device_get_connstring_doc
"device_get_connstring(pnd) -> name

Returns the device connection string. 

Parameters
----------
pnd : nfc_device
    currently used device
  
Returns
-------
name : string
    device connection string"
%enddef
%feature("autodoc", nfc_device_get_connstring_doc) nfc_device_get_connstring;
const char *nfc_device_get_connstring(nfc_device *pnd);




%define nfc_device_get_supported_modulation_doc
"device_get_supported_modulation(pnd, mode) -> (ret, supported_mt)

Get supported modulations.

Parameters
----------
pnd : nfc_device
    currently used device
mode : nfc_mode
    mode
  
Returns
-------
ret : integet
    0 on success, otherwise returns libnfc's error code (negative value) 
supported_mt : nfc_modulation_type array
    the supported modulations
"
%enddef
%feature("autodoc", nfc_device_get_supported_modulation_doc) nfc_device_get_supported_modulation;
int nfc_device_get_supported_modulation(nfc_device *pnd, const nfc_mode mode,  const nfc_modulation_type **const supported_mt);




%define nfc_device_get_supported_baud_rate_doc
"device_get_supported_baud_rate_doc(pnd, mode, nmt) -> (ret, supported_br)

Get supported baud rates.

Parameters
----------
pnd : nfc_device
    currently used device
mode : nfc_mode
    possible values: N_TARGET, N_INITIATOR
nmt : nfc_modulation_type
    desired modulation
  
Returns
-------
ret : integer
    0 on success, otherwise returns libnfc's error code (negative value) 
supported_br : nfc_modulation_type array
    supported baud rates
"
%enddef
%feature("autodoc", nfc_device_get_supported_baud_rate_doc) nfc_device_get_supported_baud_rate;
int nfc_device_get_supported_baud_rate(nfc_device *pnd, const nfc_modulation_type nmt, const nfc_baud_rate **const supported_br);




%define nfc_device_set_property_int_doc
"device_set_property_int(pnd, property, value) -> ret

Set a device's integer-property value.

Parameters
----------
pnd : nfc_device
    currently used device 
property : nfc_property
    property which will be set
value : int
    value
  
Returns
-------
ret : int
    0 on success, otherwise returns libnfc's error code (negative value)
"
%enddef
%feature("autodoc", nfc_device_set_property_int_doc) nfc_device_set_property_int;
int nfc_device_set_property_int(nfc_device *pnd, const nfc_property property, const int value);




%define nfc_device_set_property_bool_doc
"device_set_property_bool(pnd, property, bEnable) -> ret

Set a device's boolean-property value.

Parameters
----------
pnd : nfc_device
    currently used device 
property : nfc_property
    property which will be set
bEnable : bool
    activate/disactivate the property
  
Returns
-------
ret : int
    0 on success, otherwise returns libnfc's error code (negative value)"
%enddef
%feature("autodoc", nfc_device_set_property_bool_doc) nfc_device_set_property_bool;
int nfc_device_set_property_bool(nfc_device *pnd, const nfc_property property, const bool bEnable);




%define iso14443a_crc_doc
"iso14443a_crc(pbtData, szLen, pbtCrc)"
%enddef
%feature("autodoc", iso14443a_crc_doc) iso14443a_crc;
void iso14443a_crc(uint8_t *pbtData, size_t szLen, uint8_t *pbtCrc);




%define iso14443a_crc_append_doc
"iso14443a_crc_append(pbtData, szLen)"
%enddef
%feature("autodoc", iso14443a_crc_append_doc) iso14443a_crc_append;
void iso14443a_crc_append(uint8_t *pbtData, size_t szLen);




%define iso14443b_crc_doc
"iso14443b_crc(pbtData, szLen, pbtCrc)"
%enddef
%feature("autodoc", iso14443b_crc_doc) iso14443b_crc;
void iso14443b_crc(uint8_t *pbtData, size_t szLen, uint8_t *pbtCrc);




%define iso14443b_crc_append_doc
"iso14443b_crc_append(pbtData, szLen)"
%enddef
%feature("autodoc", iso14443b_crc_append_doc) iso14443b_crc_append;
void iso14443b_crc_append(uint8_t *pbtData, size_t szLen);




%define iso14443a_locate_historical_bytes_doc
"iso14443a_locate_historical_bytes(pbtAts, szAts, pszTk) -> ret"
%enddef
%feature("autodoc", iso14443a_locate_historical_bytes_doc) iso14443a_locate_historical_bytes;
uint8_t *iso14443a_locate_historical_bytes(uint8_t *pbtAts, size_t szAts, size_t *pszTk);



%define nfc_free_doc
"free(p)

Free buffer allocated by libnfc."
%enddef
%feature("autodoc", nfc_free_doc) nfc_free;
void nfc_free(void *p);




%define nfc_version_doc
"version(pnd) -> version

Returns the library version. 

Parameters
----------
pnd : nfc_device
    currently used device 

Returns
-------
  version : a string with the library version"
%enddef
%feature("autodoc", nfc_version_doc) nfc_version;
const char *nfc_version(void);




%define nfc_device_get_information_about_doc
"device_get_information_about(pnd) -> (ret, buf)

Print information about NFC device.

Parameters
----------
pnd : nfc_device
    currently used device 

Returns
-------
ret : int
    number of characters printed (excluding the null byte used to end output to strings), otherwise returns libnfc's error code (negative value)
buf : string
    information printed
"
%enddef
%feature("autodoc", nfc_device_get_information_about_doc) nfc_device_get_information_about;
int nfc_device_get_information_about(nfc_device *pnd, char **buf);




%define str_nfc_modulation_type_doc
"str_nfc_modulation_type(nmt) -> buf

Convert nfc_modulation_type value to string.

Parameters
----------
nmt : nfc_modulation_type
    modulation type

Returns
-------
buf : string
    information printed
"
%enddef
%feature("autodoc", str_nfc_modulation_type_doc) str_nfc_modulation_type;
const char *str_nfc_modulation_type(const nfc_modulation_type nmt);




%define str_nfc_baud_rate_doc
"str_nfc_baud_rate(nbr) -> buf

Convert nfc_baud_rate value to string.

Parameters
----------
nbr : nfc_baud_rate
    rate to convert

Returns
-------
buf : string
    the nfc baud rate 
"
%enddef
%feature("autodoc", str_nfc_baud_rate_doc) str_nfc_baud_rate;
const char *str_nfc_baud_rate(const nfc_baud_rate nbr);




%define str_nfc_target_doc
"str_nfc_target(pnt, verbose) -> (ret, buf)

Convert nfc_modulation_type value to string.

Parameters
----------
pnt : nfc_target
    struct to print 
verbose : bool
    verbosity

Returns
-------
ret : int
    
buf : string
    information printed
"
%enddef
%feature("autodoc", str_nfc_target_doc) str_nfc_target;
%typemap(in,numinputs=0) char **buf ($*ltype temp) %{ $1 = &temp; %}
%typemap(argout) char **buf %{ $result = SWIG_Python_AppendOutput($result, toPyString(*$1)); %}
int str_nfc_target(char **buf, const nfc_target *pnt, bool verbose);
%clear char **buf;




%include nfc/nfc-types.h
%{
#include <nfc/nfc-types.h>
%}

%include nfc/nfc.h
%{
#include <nfc/nfc.h>

#ifdef NO_ISO14443B_CRC
void iso14443b_crc(uint8_t *pbtData, size_t szLen, uint8_t *pbtCrc) {}
void iso14443b_crc_append(uint8_t *pbtData, size_t szLen) {}
#endif
%}

%pythoncode %{
__version__ = version()

import sys


def convBytes(pData):
    if sys.version_info[0] < -3:  # python 2
        byt = ord(pData)
    else:
        byt = pData
    return byt

    
def print_hex(pbtData, szBytes):
    """
    print bytes in hexadecimal
    
    Parameters
    ----------
    pbtData : bytes
        bytes to print
    szBytes : int
        size in bytes
    
    """
    for szPos in range(szBytes):
        sys.stdout.write("%02x  " % convBytes(pbtData[szPos]))
    print('')
    
    
def print_hex_bits(pbtData, szBits):
    """
    Print bits in hexadecimal
        
    Parameters
    ----------
    pbtData : bytes
        bits to print
    szBits : int
        size in bits
    
    """
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

    
def print_nfc_target(pnt, verbose):
    """
    Print a nfc_target
    
    Parameters
    ----------
    pnt : nfc_target 
        (over)writable struct
    verbose : bool    
        verbosity flag
    """
    ret, s = str_nfc_target(pnt, verbose)
    sys.stdout.write(s)    
%}
