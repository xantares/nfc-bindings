
#include "python_wrapping.h"

PyObject* toPyString(const char *buf)
{
  return PyUnicode_FromString(buf);
}

char* fromPyString(PyObject * pyObj)
{
  return PyBytes_AsString(PyUnicode_AsUTF8String(pyObj));
}

int checkPyString(PyObject * pyObj)
{
  return PyUnicode_Check(pyObj);
}

int checkPyBytes(PyObject * pyObj)
{
  return PyBytes_Check(pyObj)||PyByteArray_Check(pyObj);
}

char* fromPyBytes(PyObject * pyObj)
{
  if (PyBytes_Check(pyObj))
    return PyBytes_AsString(pyObj);
  // error
  return NULL;
}

int checkPyInt(PyObject * pyObj)
{
  return PyLong_Check(pyObj);
}
