
#include "Python.h"

inline PyObject* toPyString(const char *buf)
{
#if PY_MAJOR_VERSION >= 3
  return PyUnicode_FromString(buf);
#else
  return PyString_FromString(buf);
#endif
}

inline char* fromPyString(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_AsString(PyUnicode_AsUTF8String(pyObj));
#else
  return PyString_AsString(pyObj);
#endif
}

inline int checkPyString(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyUnicode_Check(pyObj);
#else
  return PyString_Check(pyObj);
#endif
}

inline int checkPyBytes(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyBytes_Check(pyObj)||PyByteArray_Check(pyObj);
#else
  return PyString_Check(pyObj)||PyByteArray_Check(pyObj);
#endif
}

inline char* fromPyBytes(PyObject * pyObj)
{
  if(PyByteArray_Check(pyObj))
    return PyByteArray_AsString(pyObj);
#if PY_MAJOR_VERSION >= 3
  if (PyBytes_Check(pyObj))
    return PyBytes_AsString(pyObj);
#else
  if (PyString_Check(pyObj))
    return PyString_AsString(pyObj);
#endif
  // error
  return 0;
}

inline PyObject* toPyBytes(const char *buf)
{
  return PyBytes_FromString(buf);
// #if PY_MAJOR_VERSION >= 3
//   return PyBytes_FromString(buf);
// #else
//   return PyString_FromString(buf);
// #endif
}

inline PyObject* toPyBytesSize(const char *buf, int size)
{
  return PyByteArray_FromStringAndSize(buf, size);
// #if PY_MAJOR_VERSION >= 3
//   return PyByteArray_FromStringAndSize(buf, size);
// #else
//   return PyString_FromStringAndSize(buf, size);
// #endif
}

inline int checkPyInt(PyObject * pyObj)
{
#if PY_MAJOR_VERSION >= 3
  return PyLong_Check(pyObj);
#else
  return PyInt_Check(pyObj) || PyLong_Check(pyObj);
#endif
}

inline long fromPyInt(PyObject * pyObj)
{
  return PyLong_AsUnsignedLong(pyObj);
}
