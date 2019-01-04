
#include "Python.h"

PyObject* toPyString(const char *buf);

char* fromPyString(PyObject * pyObj);

int checkPyString(PyObject * pyObj);

int checkPyBytes(PyObject * pyObj);

char* fromPyBytes(PyObject * pyObj);

int checkPyInt(PyObject * pyObj);
