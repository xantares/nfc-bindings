/* File: nfc.i */

%module(docstring="Bindings for libnfc") nfc
%feature("autodoc","1");

%{
#include <stdbool.h>

#include "Python.h"

PyObject* toPyString(const char *buf)
{
#if PY_MAJOR_VERSION >= 3
  return PyUnicode_FromString(buf);
#else
  return PyString_FromString(buf);
#endif
}

char* fromPyString(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_AsString(PyUnicode_AsUTF8String(pyObj));
#else
  return PyString_AsString(pyObj);
#endif
}

int checkPyString(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyUnicode_Check(pyObj);
#else
  return PyString_Check(pyObj);
#endif
}

int checkPyBytes(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_Check(pyObj);
#else
  return PyString_Check(pyObj);
#endif
}

char* fromPyBytes(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_AsString(pyObj);
#else
  return PyString_AsString(pyObj);
#endif
}

PyObject* toPyBytes(const char *buf)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_FromString(buf);
#else
  return PyString_FromString(buf);
#endif
}

PyObject* toPyBytesSize(const char *buf, int size)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_FromStringAndSize(buf, size);
#else
  return PyString_FromStringAndSize(buf, size);
#endif
}




int checkPyInt(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyLong_Check(pyObj);
#else
  return PyInt_Check(pyObj) || PyLong_Check(pyObj);
#endif
}

long fromPyInt(PyObject * pyObj)
{
  return PyLong_AsUnsignedLong(pyObj);
}


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

%define nfc_init_docstring
"init() -> context"
%enddef
%feature("autodoc", nfc_init_docstring) nfc_init;
//%newobject nfc_init;
%typemap(in,numinputs=0) SWIGTYPE** OUTPUT ($*ltype temp) %{ $1 = &temp; %}
%typemap(argout) SWIGTYPE** OUTPUT %{ $result = SWIG_Python_AppendOutput($result, SWIG_NewPointerObj((void*)*$1,$*descriptor,0)); %}
%apply SWIGTYPE** OUTPUT { nfc_context **context };
    void nfc_init(nfc_context **context);
%clear nfc_context **context;
%typemap(newfree) nfc_context * "nfc_exit($1);";


%define nfc_open_docstring
"open(context, connstring) -> (ret, device)"
%enddef
%feature("autodoc", nfc_open_docstring) nfc_open;
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

//%define nfc_close_docstring
//"close(device)"
//%enddef
//%feature("autodoc", nfc_close_docstring) nfc_close;
//%delobject nfc_close;

//%define nfc_exit_docstring
//"exit(context)"
//%enddef
//%feature("autodoc", nfc_exit_docstring) nfc_exit;
//%delobject nfc_exit;

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
%}
