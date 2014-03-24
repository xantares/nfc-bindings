cmake_minimum_required(VERSION 2.8)
project(nfc-bindings C)

# find_package(LibNFC NO_MODULE REQUIRED)
# include(${LIBNFC_USE_FILE})
set (LIBNFC_LIBRARIES "/home/xantares/projects/libnfc/build/install/lib/libnfc.so;/usr/lib/libusb.so")
include_directories("/home/xantares/projects/libnfc/build/install/include/")

option ( PYTHON_BINDINGS "Build python bindings via swig" ON )
if(PYTHON_BINDINGS)
  add_subdirectory(python)
endif ()




