
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